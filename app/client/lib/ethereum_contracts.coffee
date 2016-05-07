@contractInstance = undefined
waiting_for_mining = undefined

# set ethereum RPC providor
if !web3.currentProvider
  web3.setProvider new (web3.providers.HttpProvider)('http://localhost:8545')

# Helper method to get all elements in a linked list
window.getAllElements = (listContract) ->
  list = []
  head = listContract.head()

  if isZero(head)
    console.log "empty list"
    return list
  currentKey = head

  while !isZero(currentKey)
    console.log "currentKey: "
    console.log currentKey

    elem = listContract.actions(currentKey)
    # convert to JS object
    elem = web3.returnObject("actions", elem, listContract.abi)

    list.push elem
    currentKey = elem.previous

  console.log "list"
  console.log list
  return list


# get the latest block
web3.eth.filter('latest').watch (e, blockHash) ->
  if !e
    # Make sure contracts are mined
    if contractInstance == undefined
      mine_contract( Organization ) unless waiting_for_mining
    else
      # Contract exists
      last_known_block = Session.get('latestBlock') == undefined ? "" : Session.get('latestBlock').hash
      this_block = blockHash
      if last_known_block != this_block
        # Get all actions
        Session.set 'soon', getAllElements(contractInstance)

        # Save block
        web3.eth.getBlock blockHash, (e, block) ->
          Session.set 'latestBlock', block
          return

  return


isZero = (key) ->
  return true if key == '0x0000000000000000000000000000000000000000000000000000000000000000'
  if key == '0x'
    console.log "weird key: " + key
    return true
  return false

mine_contract = (Contract) ->
  waiting_for_mining = true
  # Create Contract
  # Set coinbase as the default account
  web3.eth.defaultAccount = web3.eth.coinbase

  # assemble the tx object w/ default gas value
  transactionObject =
    data: Contract.bytecode
    gasPrice: web3.eth.gasPrice
    gas: 500000
    from: web3.eth.accounts[0]
  # estimate gas cost then transact new MultiplyContract
  web3.eth.estimateGas transactionObject, (err, estimateGas) ->
    if !err
      transactionObject.gas = estimateGas
    Contract.new transactionObject, (err, contract) ->
      if err
        console.log err
      if contract.address
        console.log 'mined contract at ' + contract.address
        @contractInstance = contract
        waiting_for_mining = false
      return
    return
  return
