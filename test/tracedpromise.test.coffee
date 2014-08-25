chai = require "chai"
chaiAsPromised = require "chai-as-promised"
chai.use chaiAsPromised
chai.should()

TracedPromise = require "../lib/tracedpromise"
Q = require "q"
Promise = require "promise"

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
    , (err) ->
      err.should.not.exists

  someService = (resultArray, ifRec) ->
    trace = TracedPromise.trace()
    new TracedPromise (res, rej) ->
      setTimeout ->
        res null
      , 10
    .then ->
      resultArray.push trace if ifRec
      null

  it "call func", ->
    resultArray = []
    TracedPromise.all [1..10].map (v) ->
      TracedPromise.trace v
      someService resultArray, false
      .then ->
        someService resultArray, true
    .then ->
      error = []
      [1..10].map (c) ->
        f = resultArray.filter (v) ->
          v == c
        error.push c if f.length != 1
        null
      error.length.should.eql 0
      null
    , (err) ->
      err.should.not.exists

  it "Q.when", ->
    resultArray = []
    [1..10].map (v) ->
      -> 
        TracedPromise.trace v
        someService resultArray, false
        .then ->
          someService resultArray, true
    .reduce Q.when, Q()
    .then ->
      error = []
      [1..10].map (c) ->
        f = resultArray.filter (v) ->
          v == c
        error.push c if f.length != 1
        null
      error.length.should.eql 0
      null
    , (err) ->
      err.should.not.exists

  it "work with original promise", ->
    resultArray = []
    logger =
      log : (self) ->
        if self instanceof TracedPromise
          resultArray.push self.trace
    TracedPromise.all [1,2].map (v) ->
      if v == 1
        TracedPromise.trace 1
        return new TracedPromise (res, rej) ->
          setTimeout ->
            res null
          , 100
        .then ->
          logger.log this
          # resultArray.push this.trace if this instanceof TracedPromise
      else
        TracedPromise.trace 2
        return new Promise (res, rej) ->
          setTimeout ->
            res null
          , 100
        .then ->
          logger.log this
          # resultArray.push this.trace if this instanceof TracedPromise
    .then ->
      resultArray.should.length 1
    , (err) ->
      err.should.not.exists
