/**
Template Controllers

@module Templates
*/

Template['dashboard'].helpers({
  'actions': function(){
      return [
        {
          name: "Sail to Fuji",
          votes: 30
        },
        {
          name: "Fix mast",
          votes: 10
        }
      ];
  }
});

// When the template is created
Template['dashboard'].onCreated(function(){});
