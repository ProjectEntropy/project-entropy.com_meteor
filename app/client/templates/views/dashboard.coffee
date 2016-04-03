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
  available_ether: ->
    25.237653
  needed_ether: ->
    16825.0
# When the template is created
Template['dashboard'].onCreated ->
