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

# ROUTES

###*
The receive route, showing the wallet overview

@method dashboard
###

# Default route
Router.route '/',
  template: 'dashboard'
  name: 'dashboard'
# actions
Router.route '/actions',
  template: 'actions'
  name: 'all_actions'


Router.route '/actions/:_filter',
  template: 'actions'
  name: 'filtered_actions'

  data: ->
    filter: @params._filter
# action
Router.route '/actions/:_filter/:_id',
  template: 'action_show'
  name: 'action'

  data: ->
    Actions.findOne @params._id
