###*
Template Controllers

@module Templates
###



Template['dashboard'].helpers
  actions: ->
    Actions.find({})

  done: ->
    [
      {
        name: 'Buy 50\' catamaran for $500,000'
        description: 'We need a suitable boat for this to work'
        votes: 60
        tags: [ 'urgent' ]
      }
      {
        name: 'Buy food'
        description: 'To live, we need food'
        votes: 10
        tags: [ 'food', 'urgent' ]
      }
    ]

  available_ether: ->
    web3
    25.237653
  needed_ether: ->
    16825.0
# When the template is created
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

  # Insert Action into the collection
  data = {
    name: name
    description: description
    tags: tags.split(/[ ,]+/)
    createdAt: new Date
  }

  Actions.insert data, (error, result) ->
    if result
      # Clear form
      name_el.value = ''
      description_el.value = ''
      tags_el.value = ''
      $(target).find('.error').html('')
    else
      $(target).find('.error').html(error)
  return
