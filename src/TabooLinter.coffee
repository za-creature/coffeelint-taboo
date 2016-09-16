"use strict"


module.exports = class TabooLinter
    @default: -> defaultLinter  # initialized on the bottom of the file

    lint: (root, {@identifiers}) =>
        @errors = []
        try
            @visit(root)
            @errors.sort((a, b) -> a.lineNumber - b.lineNumber)
            return @errors
        finally
            delete @identifiers
            delete @errors

    visit: (node) =>
        handler = this["visit#{node.constructor.name}"]
        if handler?
            # assume the handler will visit its children
            handler(node)
        else
            # walk through all child nodes
            node.eachChild(@visit)
        undefined

    check: (node, name) =>
        if ~@identifiers.indexOf(name)
            @errors.push({
                lineNumber: node.first_line + 1
                message: "Accessing \"#{name}\" is not allowed"
            })

    visitValue: (node) =>
        if node.base.constructor.name is "Literal" and node.base.isAssignable()
            # simple (single-valued) object ...
            current = node.base.value
            @check(node, current)

            if node.hasProperties()
                for prop in node.properties
                    if prop.constructor.name is "Access"
                        current += ".#{prop.name.value}"
                        @check(node, current)
                    else if \
                            prop.constructor.name is "Index" and \
                            prop.index.base?.constructor.name is "Literal"
                        val = prop.index.base.value
                        if val[0] in ['"', "'"]
                            val = val.substring(1, val.length - 1)
                        current += ".#{val}"
                        @check(node, current)
                    else
                        @visit(prop)
        else
            # complex object potentially containing more values (Arr or Obj)
            node.eachChild(@visit)
        undefined


defaultLinter = new TabooLinter()
