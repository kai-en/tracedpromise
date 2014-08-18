tracedpromise
=============

[![NPM version](https://www.npmjs.org/package/tracedpromise)](https://www.npmjs.org/package/tracedpromise)

**tracedpromise** is extended from promise of node.js. You can use it as normal promise. 
It added a method named "trace" to trace the "caller" of a promise to the end of all ".then" calls.
It is useful to log every steps of a promise for a purpose, like an express function responsing an url.

Installation
------------

    npm install tracedpromise

Usage
-----

Example:

    var TracedPromise = require("tracedpromise");
    
    TracedPromise.trace({msg:"some tracing message"});
    new TracedPromise(function(res, rej) {
        // do some thing async
    })
    .then(function() {
        var traced = TracedPromise.trace();
        console.log(traced.msg);
    });

Notice
------

Be sure to use all methods from **tracedpromise**, including *.then* *.done* *.all* *.race*.

## License

**MIT**