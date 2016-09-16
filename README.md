# coffeelint-taboo

[![Circle CI](https://circleci.com/gh/za-creature/coffeelint-taboo/tree/master.svg?style=shield)](https://circleci.com/gh/za-creature/coffeelint-taboo/tree/master)
[![Dependencies](https://david-dm.org/za-creature/coffeelint-taboo.svg)](https://david-dm.org/za-creature/coffeelint-taboo)
[![Dev Dependencies](https://david-dm.org/za-creature/coffeelint-taboo/dev-status.svg)](https://david-dm.org/za-creature/coffeelint-taboo#info=devDependencies)
[![Coverage Status](https://img.shields.io/coveralls/za-creature/coffeelint-taboo.svg)](https://coveralls.io/github/za-creature/coffeelint-taboo?branch=master)

[coffeelint](http://www.coffeelint.org/) plugin that denies access to certain
identifiers that are undesirable in production such as:

* `it.only` or `describe.only`
* the `console` object
* `debugger` statements

Expected use case: ensuring no debug code gets through into production (when
run as part of CI). I learned this the hard way so you don't have to!

## Table of Contents

* [Installation](#installation)
* [License: MIT](#license)

## Installation

Add coffeelint-taboo to your project's dependencies

```bash
npm install --save coffeelint-taboo
```

Insert this somewhere into your `coffeelint.json` file (I like to keep my
custom rules at the bottom):

```
"reject_identifiers": {
    "module": "coffeelint-taboo",
    "level": "error",
    "identifiers": ["debugger", "console", "it.only", "describe.only"]
},
```


## License

coffeelint-taboo is licensed under the [MIT license](LICENSE.md).

[↑ Back to top](#table-of-contents)
