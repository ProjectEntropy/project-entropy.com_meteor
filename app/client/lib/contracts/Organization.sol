import "./TokenCreation.sol";

/*
  Interface for Entropy organization
*/
contract OrganizationInterface {
  // Todo
}

contract Organization is OrganizationInterface, Token {

  // Action types

  struct Action {

    /*enum Types {
      normal,
      blocked,
      objection,
      nomination
    }

    enum States {
      voting,
      accepted,
      rejected,
      blocked,
      done
    }*/

    bytes32 previous;     // Previous in the array
    bytes32 parent;       // Parent Action (optional)

    string name;          // The name of the Action
    string description;   // Markdown enabled description
    address from;         // Who created it
    uint created;         // Timestamp of when it was created

    uint kind;            // The Action type
                          //    0 : normal
                          //          Action will be carried out by steering commitee.
                          //          Any wie will be unlocked for this purpose.
                          //    1 : blocked
                          //          blocks parent until this new action is resolved.
                          //    2 : objection
                          //          disables the parent Action if successful
                          //          re-accepts the parent Action if successful
                          //    3 : nomination
                          //          send_to added to steering comittee


    uint state;           // The state of the Action
                          //    0 : voting
                          //          Voting is in progress and conditions have not yet been met
                          //          for the Action to move on.
                          //    1 : accepted
                          //          The Action is currently accepted
                          //    2 : rejected
                          //          The Action is currently rejected
                          //    3 : blocked
                          //          until a child Action is resolved, this Action is blocked
                          //    4 : done
                          //          This has been completed

    string tags;

    // main data
    bytes32 data;

    // ethereum handling
    uint amount;      // (optional) How much ether is available
    address send_to;  // (optional) The address ether should be sent if successful

    // votes
    uint yes_votes;  // Total yes votes
    uint no_votes;   // Total no votes
    mapping (address => bool) votedYes;
    mapping (address => bool) votedNo;

  }

  address owner;

  // first entry of the linked list of actions
  bytes32 public head;

  // total ether from all approved actions
  uint public needed_ether;

  mapping(bytes32 => Action) public actions;

  // Action change events, including voting
  event NewAction(bytes32 action_key);
  event NewVote(bytes32 action_key);

  // Constructor
  function Organization() {}

  /**
   * Vote for an action at key
   * @param key The key of the Action
   * @return Whether the vote was successful
   */
  function vote(bytes32 key) onlyTokenholders returns (bool success)
  {
    Action a = actions[key];
    a.vote_count += 1;
    NewVote(key);
    return true;
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
    a.previous = head;

    // Set this element as the new head.
    head = key;

    // Update global record of amount of funds needed
    needed_ether += a.amount;


    NewAction(key);
    return true;
  }

  // Only people who hold at least one token can do these actions
  modifier onlyTokenholders {
    if (balanceOf(msg.sender) == 0) throw;
    _
  }
}
