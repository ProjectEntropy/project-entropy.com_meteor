@contractInstance = undefined
@waiting_for_mining = undefined

# set ethereum RPC providor
if !web3.currentProvider
  web3.setProvider new (web3.providers.HttpProvider)('http://localhost:8545')


window.get_actions = ->
  Session.set 'soon', getAllElements(contractInstance)

window.scan_contract = (blockHash) ->
  # Make sure contracts are mined
  if contractInstance == undefined
    find_or_mine_contract( Organization, Session.get("entropyDappAddress") ) unless waiting_for_mining
  else
    # Contract exists
    last_known_block = Session.get('latestBlock') == undefined ? "" : Session.get('latestBlock').hash

    if (last_known_block != blockHash) || Session.get 'soon' == undefined
      get_actions()

      # Save block
      web3.eth.getBlock blockHash, (e, block) ->
        Session.set 'latestBlock', block
        return

window.wait_for_block_mined = (err, contract) ->
  if err
    console.log err
  if contract.address
    console.log 'mined contract at ' + contract.address
window.after_tx_callback = (err, contract) ->
  if err
    console.log err
  if contract.address
    console.log 'mined contract at ' + contract.address
    Session.setPersistent('entropyDappAddress', contract.address)
    @contractInstance = contract
    @waiting_for_mining = false

    # Add some test activities
    # function addAction(bytes32 key, string _name, string _description, uint _kind, bytes32 _data, uint _amount)
    for num in [1..50]
      contractInstance.addAction.sendTransaction( num, "Sail to Fuji", "we should sail to fuji", 1, "0x" + web3.sha3("data?"), 10, {from: web3.eth.accounts[0], gas:1000000}, (err, result) ->
        console.log "Added a new action"
        )

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


  # if existing_contract_instance.address
  #   console.log "Found existing contract at: " + existing_contract_instance.address
  #   console.log existing_contract_instance
  #
  #   @contractInstance = existing_contract_instance
  #   @waiting_for_mining = false
  #   get_actions()
  #   return

  # check it's code matches the latest contract code

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




# get the latest block
web3.eth.filter('latest').watch (e, blockHash) ->
  if !e
    console.log "| new block seen |"
    scan_contract(blockHash)

  return
