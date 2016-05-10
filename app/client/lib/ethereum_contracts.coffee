@contractInstance = undefined
@waiting_for_mining = undefined

# set ethereum RPC providor
if !web3.currentProvider
  web3.setProvider new (web3.providers.HttpProvider)('http://localhost:8545')


window.scan_contract = (blockHash) ->
  # Make sure contracts are mined
  if contractInstance == undefined
    find_or_mine_contract( Organization, Session.get("entropyDappAddress") ) unless waiting_for_mining
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

# get the latest block
web3.eth.filter('latest').watch (e, blockHash) ->
  if !e
    console.log "| new block seen |"
    scan_contract(blockHash)

  return

window.after_tx_callback = (err, contract) ->
  if err
    console.log err
  if contract.address
    console.log 'mined contract at ' + contract.address
    Session.setPersistent('entropyDappAddress', contract.address)
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


window.find_or_mine_contract = (Contract, address) ->
  @waiting_for_mining = true

  # check if contract exists
  existing_contract_instance = Contract.at(address)
  new_contract_instance =  Contract.new

  console.log "checking at: " + address
  console.log "found"
  console.log existing_contract_instance


  if existing_contract_instance.address
    console.log "Found existing contract at: " + existing_contract_instance.address
    console.log existing_contract_instance

    @contractInstance = existing_contract_instance
    @waiting_for_mining = false
    return

  # check it's code matches the latest contract code
  # debugger

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
    console.log "Creating new contract"
    Contract.new transactionObject, after_tx_callback
    return
  return


# Do one scan straight away
scan_contract()
