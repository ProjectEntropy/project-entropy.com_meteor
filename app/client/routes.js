/**
Template Controllers

@module Routes
*/

/**
The app routes

@class App routes
@constructor
*/

// Change the URLS to use #! instead of real paths
// Iron.Location.configure({useHashPaths: true});

// Router defaults
Router.configure({
    layoutTemplate: 'layout_main',
    notFoundTemplate: 'layout_notFound',
    yieldRegions: {
        'layout_header': {to: 'header'}
        , 'layout_footer': {to: 'footer'}
    },
    progress: false,
    progressSpinner : true
});

// ROUTES

/**
The receive route, showing the wallet overview

@method dashboard
*/

// Default route
Router.route('/', {
    template: 'dashboard',
    name: 'home'
});

// actions
Router.route('/actions', {
    template: 'actions',
    name: 'actions'
});

// action
Router.route('/actions/:_id', {
    template: 'action_show',
    name: 'action',
    data: function(){
      return Actions.findOne(this.params._id)
    }

});


// Route for view1
Router.route('/view1', {
    template: 'views_view1',
    name: 'view1'
});

// Route for view2
Router.route('/view2', {
    template: 'views_view2',
    name: 'view2'
});
