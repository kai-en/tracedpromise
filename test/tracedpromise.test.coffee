chai = require "chai"
chaiAsPromised = require "chai-as-promised"
chai.use chaiAsPromised
chai.should()

TracedPromise = require "../lib/tracedpromise"

describe "TracedPromise", ->
  it "paralell", ->
    result = []
    TracedPromise.all [1,2].map (v) ->
      TracedPromise.trace msg:"doing " + v
      new TracedPromise (res, rej) ->
        setTimeout ->
          res null
        , 100
      .then ->
        trace = TracedPromise.trace()
        result.push
          src: trace
          now: msg:"doing " + v
        null
    .then ->
      error = []
      toCheck = [1,2].map (v) ->
        "doing " + v
      .map (c) ->
        f = result.filter (v) ->
          v.src.msg == c && v.src.msg == v.now.msg
        error.push "not found " + c if f.length == 0
        null
      error.length.should.eql 0
      null

  
