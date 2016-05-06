@contractInstance = undefined
@waiting_for_mining = undefined

# set ethereum RPC providor
if !web3.currentProvider
  web3.setProvider new (web3.providers.HttpProvider)('http://localhost:8545')



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


after_tx_callback = (err, contract) ->
  if err
    console.log err
  if contract.address
    console.log 'mined contract at ' + contract.address
    @contractInstance = contract
    @waiting_for_mining = false

    # Add some test activities
    # addAction(bytes32 key, string _name, string _description, uint _kind, bytes32 _data, uint _amount) returns (bool){
    contractInstance.addAction.sendTransaction( 1, "Sail to Fuji", "we should sail to fuji", 1, 1, "0x" + web3.sha3("data?"), 10, {from: web3.eth.accounts[0], gas:1000000}, (err, result) ->
      console.log "Added a new action"
      console.log "result"
      console.log result )

    contractInstance.addAction.sendTransaction( 2, "Buy boat", "Buy a catamaran", 1, 1, "0x" + web3.sha3("data?"), 10, {from: web3.eth.accounts[0], gas:1000000}, (err, result) ->
      console.log "Added a new action"
      console.log "result"
      console.log result )
  else
    console.log "waiting for contract to be mined..."
  return


mine_contract = (Contract) ->
  @waiting_for_mining = true
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
    Contract.new transactionObject, after_tx_callback
    return
  return
