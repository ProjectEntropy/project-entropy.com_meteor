
window.isZero = (key) ->
  try
    key = new BigNumber(key)
    return true if key.eq(0)

  catch e
    console.log e

  return false


# Helper method to get all elements in a linked list
window.getAllElements = (listContract) ->
  list = []
  head = listContract.head()

  if isZero(head)
    return list
  currentKey = head

  while !isZero(currentKey)
    elem = listContract.actions(currentKey)
    # convert to JS object
    elem = web3.returnObject("actions", elem, listContract.abi)

    list.push elem
    currentKey = elem.previous

  return list
