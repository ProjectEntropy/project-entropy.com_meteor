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
        }
      ];
  }
});

// When the template is created
Template['dashboard'].onCreated(function(){});
