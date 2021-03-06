# disconnect any meteor server
if location.host != 'localhost:3000' and location.host != '127.0.0.1:3000' and typeof MochaWeb == 'undefined'
  Meteor.disconnect()

# Set the default unit to ether
if !LocalStore.get('etherUnit')
  LocalStore.set 'etherUnit', 'ether'

# Set Session default values for components
if Meteor.isClient
  Session.setDefault 'balance', '0'

Meteor.startup ->
  # # Setup EthAccounts
  # EthAccounts.init()

  # SET default language
  if Cookie.get('TAPi18next')
    TAPi18n.setLanguage Cookie.get('TAPi18next')
  else
    userLang = navigator.language or navigator.userLanguage
    availLang = TAPi18n.getLanguages()
    # set default language
    if _.isObject(availLang) and availLang[userLang]
      TAPi18n.setLanguage userLang
      # lang = userLang;
    else if _.isObject(availLang) and availLang[userLang.substr(0, 2)]
      TAPi18n.setLanguage userLang.substr(0, 2)
      # lang = userLang.substr(0,2);
    else
      TAPi18n.setLanguage 'en'
      # lang = 'en';

  # Setup Moment and Numeral i18n support
  Tracker.autorun ->
    if _.isString(TAPi18n.getLanguage())
      moment.locale TAPi18n.getLanguage().substr(0, 2)
      numeral.language TAPi18n.getLanguage().substr(0, 2)
    return

  # Set Meta Title
  Meta.setTitle TAPi18n.__('dapp.app.title')
  return
