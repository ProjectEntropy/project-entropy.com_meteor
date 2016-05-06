

contract Organization {
  struct Action {
    bytes32 previous;
    bytes32 next;

    string name;
    string description;
    
    address from;
    uint kind;

    string tags;

    // main data
    bytes32 data;

    // ethereum handling
    uint amount;      // (optional) How much ether is available
    address send_to;  // (optional) The address ether should be sent if successful

    // votes
    uint vote_count;  // Total votes
    uint created;
  }

  address owner;


  bytes32 public head;

  mapping(bytes32 => Action) public actions;

  // Constructor
  function Organization() {
    head = "head";
  }


  function addAction(bytes32 key, string _name, string _description, uint _kind, bytes32 _data, uint _amount) returns (bool){
    Action a = actions[key];

    // Safety check incase it's not empty
    if(a.data != ""){
      return false;
    }

    a.name = _name;
    a.description = _description;
    a.data = _data;
    a.kind = _kind;

    a.amount = _amount;

    a.from = msg.sender;
    a.created = now;

    // Link
    actions[head].next = key;
    a.previous = head;

    // Set this element as the new head.
    head = key;

    return true;
  }

}
