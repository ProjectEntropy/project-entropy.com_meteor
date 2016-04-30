

contract Organization {
  struct Action {
    address previous;
    address next;

    // main data
    bytes32 data;

    // ethereum handling
    uint amount;      // (optional) How much ether is available
    address send_to;  // (optional) The address ether should be sent if successful

    // votes
    uint vote_count;  // Total votes
  }

  address owner;

  uint public size;
  address public tail;
  address public head;
  mapping(address => Action) public actions;


  function getData(address key) returns (bytes32){
    return actions[key].data;
  }
  function getVote_count(address key) returns (uint){
    return actions[key].vote_count;
  }

  function addAction(address key, bytes32 data) returns (bool){
    Action elem = actions[key];
    // Check that the key is not already taken. We have no null-check for structs atm., so
    // we need to check the fields inside the structs to verify. This works if the field we
    // check is not allowed to be the null value (which would be "" in the case of strings).
    if(elem.data != ""){
      return false;
    }

    elem.data = data;

    // Two cases - empty or not.
    if(size == 0){
      tail = key;
      head = key;
    } else {
      // Link
      actions[head].next = key;
      elem.previous = head;
      // Set this element as the new head.
      head = key;
    }
    // Regardless of case, increase the size of the list by one.
    size++;
    return true;
  }

  function removeAction(address key) returns (bool result) {

     Action elem = actions[key];

    // If no element - return false. Nothing to remove.
    if(elem.data == ""){
      return false;
    }

    // If this is the only element.
    if(size == 1){
      tail = 0x0;
      head = 0x0;
    // If this is the head.
    } else if (key == head){
      // Set this ones 'previous' to be the new head, then change its
      // next to be null (used to be this one).
      head = elem.previous;
      actions[head].next = 0x0;
    // If this one is the tail.
    } else if(key == tail){
      tail = elem.next;
      actions[tail].previous = 0x0;
    // Now it's a bit tougher. Getting here means the list has at least 3 actions,
    // and this element must have both a 'previous' and a 'next'.
    } else {
      address prevElem = elem.previous;
      address nextElem = elem.next;
      actions[prevElem].next = nextElem;
      actions[nextElem].previous = prevElem;
    }
    // Regardless of case, we will decrease the list size by 1, and delete the actual entry.
    size--;
    delete actions[key];
    return true;
  }

  function multiply(uint a) returns(uint d) {
    return a * 10;
  }
}
