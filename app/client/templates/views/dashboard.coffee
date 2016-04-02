###*
Template Controllers

@module Templates
###

Template['dashboard'].helpers
  'actions': ->
    [
      {
        name: 'Sail to Fuji'
        votes: 30
      }
      {
        name: 'Fix mast'
        votes: 10
      }
    ]
  'available_ether': ->
    25.237653
  'needed_ether': ->
    16825
# When the template is created
Template['dashboard'].onCreated ->
