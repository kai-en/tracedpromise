chai = require "chai"
chaiAsPromised = require "chai-as-promised"
chai.use chaiAsPromised
chai.should()

TracedPromise = require "../lib/tracedpromise"
Q = require "q"

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
