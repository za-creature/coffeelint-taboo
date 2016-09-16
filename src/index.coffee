"use strict"
TabooLinter = require "./TabooLinter"


module.exports = class CoffeelintTaboo
    rule:
        name: "reject_identifiers"
        description: """
            <p>This rule denies access to certain identifiers that are
            undesirable in production such as:</p>

            <ul>
                <li><code>it.only</code> or <code>describe.only</code></li>
                <li>The <code>console</code> object</li>
                <li><code>debugger</code> statements</li>
            </ul>
        """
        level: "warn"
        message: "Denied identifier"

        # global variable config
        identifiers: ["it.only", "describe.only", "console", "debugger"]

    lintAST: (root, {config, createError}) ->
        for spec in TabooLinter.default().lint(root, config[@rule.name])
            @errors.push(createError(spec))
        undefined


module.exports.TabooLinter = TabooLinter
