Promise = require "promise"

tracing = null

module.exports = TracedPromise = (res, rej) ->
  this.trace = tracing
  this.p = new Promise res, rej
  null

TracedPromise.prototype.then = (resFunc, rejFunc) ->
  trace = this.trace
  if resFunc?
    newRes = =>
      tracing = trace
      resFunc.apply this, arguments
  else
    newRes = null
  if rejFunc?
    newRej = =>
      tracing = trace
      rejFunc.apply this, arguments
  else
    newRej = null
  this.p = this.p.then newRes, newRej
  this

TracedPromise.prototype.done = (resFunc, rejFunc) ->
  trace = this.trace
  if resFunc?
    newRes = =>
      tracing = trace
      resFunc.apply this, arguments
  else
    newRes = null
  if rejFunc?
    newRej = =>
      tracing = trace
      rejFunc.apply this, arguments
  else
    newRej = null
  this.p.done newRes, newRej

TracedPromise.resolve = (result) ->
  new TracedPromise (res, rej) ->
    res result

TracedPromise.reject = (err) ->
  new TracedPromise (res, rej) ->
    rej err
    
TracedPromise.all = (arg) ->
  then: (respFunc) ->
    Promise.all arg
    .then (result) ->
      new TracedPromise (res, rej) ->
        res result
      .then respFunc
    , (err) ->
      new TracedPromise (res, rej) ->
        rej err

TracedPromise.trace = (toTrace) ->
  return tracing = toTrace if toTrace?
  tracing
