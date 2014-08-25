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
        // if you use this static way before, you will not know if it is from a normal Promise
        // so you may log some messages are not belong to this normal Promise
        // but in this way, you should not be worried about the "this" pointer be changed

        // or you can use the "this" pointer as after
        if (this instanceof TracedPromise) {
          traced = this.trace
          console.log(traced.msg);
        } 
        // in this case you will know it is not from a normal Promise so you didn't log for normal Promise
        // but you should be careful do not change the "this" pointer
        // you should only use "this.trace" in the ".then" callback
        
    });

Notice
------

Be sure to use all methods from **tracedpromise**, including *.then* *.done* *.all* *.race*.

## License

**MIT**