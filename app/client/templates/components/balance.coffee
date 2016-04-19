###*
Template Controllers

@module Templates
###

###*
The balance template

@class [template] components_balance
@constructor
###

# when the template is rendered
Template['components_balance'].onRendered ->
  # get coinbase address
  coinbase = web3.eth.coinbase
  # balance update interval
  @updateBalance = Meteor.setInterval((->
    # get the coinbase address balance
    web3.eth.getBalance coinbase, (err, result) ->
      # set global temp session balance with result
      Session.set 'balance', String(result)
      return
    return
  ), 5 * 1000)
  return
# when the template is destroyed
Template['components_balance'].onDestroyed ->
  # clear the balance update interval
  Meteor.clearInterval @updateBalance
  return
Template['components_balance'].helpers 'watchBalance': ->
  Helpers.formatNumber web3.fromWei(Session.get('balance'), LocalStore.get('etherUnit')).toString 10
