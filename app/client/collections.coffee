# Basic (local) collections
# we use {connection: null} to prevent them from syncing with our not existing Meteor server

Schemas = {}
Schemas.Action = new SimpleSchema(
  name:
    type: String
    label: 'name'
    max: 150
  description:
    type: String
    label: 'description'
    max: 400)

@Actions = new Mongo.Collection('entropy_actions', {connection: null})

new PersistentMinimongo(Actions)

Actions.attachSchema(Schemas.Action)
