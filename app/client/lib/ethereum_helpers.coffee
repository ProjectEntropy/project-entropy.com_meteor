
window.isZero = (key) ->
  return true if key == '0x0000000000000000000000000000000000000000000000000000000000000000'
  if key == '0x'
    console.log "weird key: " + key
    return true
  return false


# Helper method to get all elements in a linked list
window.getAllElements = (listContract) ->
  list = []
  head = listContract.head()

  if isZero(head)
    console.log "empty list"
    return list
  currentKey = head

  while !isZero(currentKey)
    console.log "currentKey: "
    console.log currentKey

    elem = listContract.actions(currentKey)
    # convert to JS object
    elem = web3.returnObject("actions", elem, listContract.abi)

    list.push elem
    currentKey = elem.previous

  console.log "list"
  console.log list
  return list
