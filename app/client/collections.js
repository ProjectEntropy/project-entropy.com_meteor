
// Basic (local) collections
// we use {connection: null} to prevent them from syncing with our not existing Meteor server

Actions = new Mongo.Collection('entropy_actions', {connection: null});
new PersistentMinimongo(Actions);
