###*
Template Controllers

@module Templates
###

Template['dashboard'].helpers
  actions: ->
    [
      {
        name: 'Sail to Fuji'
        description: 'Tropical Island in need of a makerspace'
        votes: 30
        tags: [ 'destination' ]
      }
      {
        name: 'Fix mast'
        description: 'main halyard is fraying'
        votes: 10
        tags: [ 'repair', 'urgent' ]
      }
      {
        name: 'Resupply food'
        description: 'We need food for the next 2 weeks'
        votes: 5
        tags: [ 'food' ]
      }
    ]

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
    25.237653
  needed_ether: ->
    16825.0
# When the template is created
Template['dashboard'].onCreated ->
