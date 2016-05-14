###*
Template Controllers

@module Routes
###

###*
The app routes

@class App routes
@constructor
###

# Change the URLS to use #! instead of real paths
# Iron.Location.configure({useHashPaths: true});
# Router defaults
Router.configure
  layoutTemplate: 'layout_main'
  notFoundTemplate: 'layout_notFound'
  yieldRegions:
    'layout_header': to: 'header'
    'layout_footer': to: 'footer'
  progress: false
  progressSpinner: true

Router.configure
  layoutTemplate: 'layout_static'
# ROUTES

###*
The receive route, showing the wallet overview

@method dashboard
###

# Default route
Router.route '/',
  template: 'home'
  name: 'home'
  layoutTemplate: 'layout_static'

Router.route '/dashboard',
  template: 'dashboard'
  name: 'dashboard'
  layoutTemplate: 'layout_main'
# actions
Router.route '/actions',
  template: 'actions'
  name: 'all_actions'
  layoutTemplate: 'layout_main'

Router.route '/actions/:_filter',
  template: 'actions'
  name: 'filtered_actions'
  layoutTemplate: 'layout_main'
  data: ->
    filter: @params._filter
# action
Router.route '/actions/:_filter/:_id',
  template: 'action_show'
  name: 'action'
  layoutTemplate: 'layout_main'
  data: ->
    Actions.findOne @params._id
