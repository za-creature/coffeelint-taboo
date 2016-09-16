"use strict"
{expect} = require "chai"
proxyquire = require "proxyquire"


describe "coffeelint-taboo", ->
    it "should be a coffeelint AST module", ->
        CoffeelintTaboo = require "../src"
        CoffeelintTaboo.should.be.an.instanceof(Function)
        CoffeelintTaboo::should.have.deep.property("rule.name",
                                                  "reject_identifiers")
        CoffeelintTaboo::should.have.deep.property("rule.description")
        CoffeelintTaboo::should.have.deep.property("rule.message")
        CoffeelintTaboo::should.have.property("lintAST")


    it "should default to warn", ->
        CoffeelintTaboo = require "../src"
        CoffeelintTaboo::should.have.deep.property("rule.level", "warn")


    it "should forward the root and only the relevant config", ->
        calledWith = null
        CoffeelintTaboo = proxyquire "../src",
            "./TabooLinter":
                default: ->
                    lint: ->
                        calledWith = arguments

        taboo = new CoffeelintTaboo()

        taboo.errors = []
        taboo.lintAST("foo", {
            config: {
                bar: "baz"
                reject_identifiers: {
                    hello: "world"
                }
            }
            createError: (e) -> e
        })
        expect(calledWith).to.exist
        calledWith[0].should.equal("foo")
        calledWith[1].should.have.property("hello", "world")


    it "converts and stores all errors", ->
        CoffeelintTaboo = proxyquire "../src",
            "./TabooLinter":
                default: ->
                    lint: -> ["foo", "bar", "baz"]

        converted = 0
        taboo = new CoffeelintTaboo()

        taboo.errors = []
        result = taboo.lintAST("foo", {
            config: {
                bar: "baz"
                reject_identifiers: {
                    hello: "world"
                }
            }
            createError: (e) ->
                converted += 1
                return "conv" + e
        })
        expect(result).to.not.exist
        converted.should.equal(3)
        taboo.errors.should.have.length(3)
        taboo.errors.should.contain("convfoo")
        taboo.errors.should.contain("convbar")
        taboo.errors.should.contain("convbaz")
