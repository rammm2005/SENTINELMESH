import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Array "mo:base/Array";

module {
  public type Node = {
    id : Text;
    ip : Text;
    owner : Principal;
    status : Text;
  };

  public func newNode(owner : Principal, id : Text, ip : Text) : Node {
    {
      id = id;
      ip = ip;
      owner = owner;
      status = "active";
    };
  };

  public func updateNodeStatus(nodes : [Node], id : Text, status : Text) : [Node] {
    Array.map<Node, Node>(
      nodes,
      func(n) {
        if (n.id == id) { { n with status = status } } else { n };
      },
    );
  };

  public func removeNode(nodes : [Node], id : Text) : [Node] {
    Array.filter<Node>(nodes, func(n) { n.id != id });
  };
};
