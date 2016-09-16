"use strict"
{nodes} = require "coffee-script"

TabooLinter = require "../src/TabooLinter"


describe "TabooLinter", ->
    it "matches simple identifiers", ->
        TabooLinter.default().lint(nodes(
            """
            foo
            """
        ), {
            identifiers: ["debugger"]
        }).should.have.length(0)

        TabooLinter.default().lint(nodes(
            """
            debugger
            """
        ), {
            identifiers: ["debugger"]
        }).should.have.length(1)


    it "ignores strings and comments", ->
        TabooLinter.default().lint(nodes(
            """
            "debugger"
            """
        ), {
            identifiers: ["debugger"]
        }).should.have.length(0)

        TabooLinter.default().lint(nodes(
            """
            # debugger
            """
        ), {
            identifiers: ["debugger"]
        }).should.have.length(0)


    it "goes into functions", ->
        TabooLinter.default().lint(nodes(
            """
            foo = ->
                debugger
            """
        ), {
            identifiers: ["debugger"]
        }).should.have.length(1)


    it "matches compound expressions", ->
        TabooLinter.default().lint(nodes(
            """
            console.log("foo")
            """
        ), {
            identifiers: ["console"]
        }).should.have.length(1)


    it "matches compound identifiers", ->
        TabooLinter.default().lint(nodes(
            """
            console.error("foo")
            """
        ), {
            identifiers: ["console.log"]
        }).should.have.length(0)

        TabooLinter.default().lint(nodes(
            """
            console.log("foo")
            """
        ), {
            identifiers: ["console.log"]
        }).should.have.length(1)


    it "matches compound identifiers with simple array access", ->
        TabooLinter.default().lint(nodes(
            """
            console["error"]("foo")
            """
        ), {
            identifiers: ["console.log"]
        }).should.have.length(0)

        TabooLinter.default().lint(nodes(
            '''
            console[0]("foo")
            '''
        ), {
            identifiers: ["console.0"]
        }).should.have.length(1)

        TabooLinter.default().lint(nodes(
            """
            console["log"]("foo")
            """
        ), {
            identifiers: ["console.log"]
        }).should.have.length(1)

        TabooLinter.default().lint(nodes(
            """
            console['log']("foo")
            """
        ), {
            identifiers: ["console.log"]
        }).should.have.length(1)


    it "ignores compound identifiers with comprehension array access", ->
        TabooLinter.default().lint(nodes(
            '''
            unused = ""
            console["log#{unused}"]("foo")
            '''
        ), {
            identifiers: ["console.log"]
        }).should.have.length(0)

    it "ignores compound identifiers with expression array access", ->
        TabooLinter.default().lint(nodes(
            '''
            console["lo" + "g"]("foo")
            '''
        ), {
            identifiers: ["console.log"]
        }).should.have.length(0)


    it "sorts errors by line number", ->
        errors = TabooLinter.default().lint(nodes(
            """
            console.log
            console.error
            """
        ), {
            identifiers: ["console.log", "console.error"]
        })
        errors.should.have.length(2)
        errors[0].message.should.contain("log")
        errors[1].message.should.contain("error")
