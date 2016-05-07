###*
Template Controllers

@module Templates
###

# Construct Multiply Contract Object and contract instance

Template['dashboard'].helpers
  actions: ->
    Actions.find({})

  soon: ->
    Session.get('soon')

  done: ->
    Session.get('done')

  available_ether: ->
    web3
    25.237653
  needed_ether: ->
    16825.0

# When the template is created
Template['dashboard'].onRendered ->

  # @updateSoonActions = Meteor.setInterval((->
  #   # debugger
  #   # console.log getAllElements(contractInstance)
  #   # Session.set 'soon', getAllElements(contractInstance)
  #
  #   # Add some actions
  #   params1 = "0x" + web3.sha3( JSON.stringify({
  #     data: "test"
  #   }))
  #
  #   params2 = {
  #     data: "test2"
  #   }
  #   # function addAction(bytes32 key, string _name, uint _kind, bytes32 _data, uint _amount) returns (bool){

  #
  #   # debugger
  #
  # ), 5 * 1000)
  return

Template['dashboard'].onDestroyed ->
  return

# Submit form
Template['dashboard'].events 'submit .new-action': (event) ->
  # Prevent default browser form submit
  event.preventDefault()
  # Get value from form element
  target = event.target

  name_el = $(target).find('[name="name"]')[0]
  description_el = $(target).find('[name="description"]')[0]
  tags_el = $(target).find('[name="tags"]')[0]

  name = name_el.value
  description = description_el.value
  tags = tags_el.value

  params1 = "0x" + web3.sha3(description)

  contractInstance.addAction.sendTransaction( contractInstance.address, name, ( "0x" + web3.sha3(description) ), 1, params1, 10, {from: web3.eth.accounts[0], gas:1000000}, (err, result) ->
    console.log "Added a new action"
    console.log "err"
    if err
      $(target).find('.error').html(error)
    else
       # Clear form
      name_el.value = ''
      description_el.value = ''
      tags_el.value = ''
      $(target).find('.error').html('')
      
    console.log "result"
    console.log result )

  #
  # # Insert Action into the collection
  # data = {
  #   name: name
  #   description: description
  #   tags: tags.split(/[ ,]+/)
  #   createdAt: new Date
  # }
  #
  # Actions.insert data, (error, result) ->
  #   if result
  #     # Clear form
  #     name_el.value = ''
  #     description_el.value = ''
  #     tags_el.value = ''
  #     $(target).find('.error').html('')
  #   else
  #     $(target).find('.error').html(error)
  return
