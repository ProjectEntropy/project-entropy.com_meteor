###*
Helper functions for the web3 module

@module web3
*
###

###*
Is the object provided a Bignumber object.

@method (isBigNumber)
*
###

web3.isBigNumber = (value) ->
  if _.isUndefined(value) or !_.isObject(value)
    return false
  value instanceof BigNumber or value.constructor.name == 'BigNumber'

###*
Return a valid web3 address. If input param 'value' is zero, it will generate address '0x0000'.

@method (address)
@param {String|Number} value     The valud to transform into an address.
*
###

web3.address = (value) ->
  nullAddress = '0x0000000000000000000000000000000000000000'
  if value == 0 or parseInt(value) == 0
    return nullAddress
  if value.substr(0, 2) == '0x'
    value = '0x' + value
  if value.length > 42 or value.length < 42
    value = nullAddress
  value

web3.clean = (val) ->
  val.replace /\0/g, ''

toAsciiMethod = web3.toAscii

web3.toAscii = (value) ->
  web3.clean toAsciiMethod(value)


###*
Build return object from array and ABI.

@method (returnObject)
@param {String} method     The name of the method in question
@param {Array} resultArray The result array values from the call
@param {Object} abi        The abi data
*
###

web3.returnObject = (method, resultArray, abi) ->
  return_object = {}
  methodIndex = null
  if _.isUndefined(method) or _.isUndefined(resultArray) or _.isUndefined(abi)
    return return_object
  _.each abi, (property, propertyIndex) ->
    if property.name == method
      methodIndex = propertyIndex
    return
  if methodIndex == null
    return return_object
  if !_.isArray(resultArray)
    resultArray = [ resultArray ]
  _.each abi[methodIndex].outputs, (item, itemIndex) ->
    return_object[item.name] = resultArray[itemIndex]
    if item.type == 'bytes32'
      return_object[item.name + 'Ascii'] = web3.toAscii(return_object[item.name])
      return_object[item.name] = return_object[item.name]
    if web3.isBigNumber(resultArray[itemIndex])
      #return_object[item.name + 'BN'] = return_object[item.name];
      return_object[item.name] = return_object[item.name].toNumber(10)
    return
  return_object

###*
Get a methods options (i.e. transactionObject/callObject and callback).

@method (getMethodDetails)
@param {Array} args     The methods args.
@return {Object} An object that contains the transactionObject and callback.
*
###

web3.getMethodDetails = (args) ->
  options =
    transactionObject: {}
    transactionObjectIndex: -1
    callback: (err, result) ->
    callbackIndex: -1
  length = args.length
  _.each args, (arg, argIndex) ->
    if _.isObject(arg) and !_.isArray(arg) and !web3.isBigNumber(arg) and !_.isString(arg) and !_.isNumber(arg) and !_.isFunction(arg) and argIndex > length - 3
      # last two args
      options.transactionObject = arg
      options.transactionObjectIndex = argIndex
    if _.isFunction(arg) and !web3.isBigNumber(arg) and !_.isString(arg) and !_.isNumber(arg) and argIndex > length - 3
      options.callback = arg
      options.callbackIndex = argIndex
    return
  options


###*
Build a web3 contract method array, with a new transaction/call object and callback;

@method (buildMethodArray)
@param {Array} args     The methods args.
@return {Object} An object that contains the transactionObject and callback.
*
###

web3.buildMethodArray = (args, obj, callback) ->
  if _.isUndefined(callback)

    callback = (err, result) ->

  if _.isUndefined(obj)
    obj = {}
  options = web3.getMethodDetails(args)
  length = args.length
  if length == 0
    length = 2
  if options.transactionObjectIndex == -1
    args[length - 2] = obj
  if options.transactionObjectIndex > -1
    args[options.transactionObjectIndex] = _.extend(options.transactionObject, obj)
  if options.callbackIndex == -1
    args[length - 1] = callback
  if options.callbackIndex > -1
    args[options.callbackIndex] = callback
  args


###*
Build a web3 contract instance with some new custom methods. This will override the previous method, if any, and add the method properties from the contract instance, if any.

@method (buildInstance)
@param {Array} args     The methods args.
@return {Object} An object that contains the transactionObject and callback.
*
###

web3.buildInstance = (Instance, methods) ->
  _.each _.keys(methods), (key) ->
    instanceMethod = Instance[key]
    newMethod = methods[key]
    if _.isObject(Instance[key])
      _.each _.keys(Instance[key]), (mKey) ->
        newMethod[mKey] = Instance[key][mKey]
        return
    Instance[key] = newMethod
    return
  Instance

web3.eth.contractus = (abi, code, options, methods) ->
  if _.isUndefined(options)
    options =
      transactionObject: gas: 3000000
      callObject: {}
  if _.isUndefined(methods)
    methods = {}
  return_object =
    abi: abi
    code: code
    methods: methods
    options: options

  return_object.at = (address) ->
    Contract = web3.eth.contract(return_object.abi)
    Instance = web3.buildInstance(Contract.at(address), return_object.methods)
    Instance.Instance = Contract.at(address)
    Instance

  return_object.new = ->
    `var options`
    args = Array::slice.call(arguments)
    Contract = web3.eth.contract(return_object.abi)
    options = web3.getMethodDetails(args)
    transactionObject = _.extend(_.extend(return_object.options.transactionObject, options.transactionObject), data: return_object.code)

    callback = (err, result) ->
      options.callback err, result, false
      if _.isUndefined(result) or !_.has(result, 'address')
        return
      if result.address
        options.callback err, return_object.at(result.address), true
      return

    buildArgs = web3.buildMethodArray(args, transactionObject, callback)
    Contract.new.apply Contract, buildArgs
    return

  return_object


  # Helpers for dealing with weird data
  isHexPrefixed: (str) ->
    str.slice(0, 2) == '0x'
  stripHexPrefix: (str) ->
    if typeof str != 'string'
      return str
    if @isHexPrefixed(str) then str.slice(2) else str
  unpad: (a) ->
    a = @stripHexPrefix(a)
    first = a[0]
    while a.length > 0 and first.toString() == '0'
      a = a.slice(1)
      first = a[0]
    a
