contract Organization {
  struct Person {
    address delegate;
  }
  struct Proposal {
    uint amount;      // (optional) How much ether is available
    address send_to;  // (optional) The address ether should be sent if successful
    uint vote_count;  // Total votes
  }

  address owner;
  Proposal[] proposals;

  function multiply(uint a) returns(uint d) {
    return a * 10;
  }
}
