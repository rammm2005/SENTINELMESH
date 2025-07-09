import Text "mo:base/Text";
import Array "mo:base/Array";

// `Principal` tidak pernah dipakai langsung di file ini

import Nodes "../services/node";
import Threats "../services/threats";
import Audit "../services/audit";
import Users "../services/users";

actor SentinelMesh {

    var nodes : [Nodes.Node] = [];
    var threats : [Threats.Threat] = [];
    var auditLogs : [Text] = [];
    var users : [Users.User] = [];

    public query func hello() : async Text {
        "SentinelMesh backend is alive 🚀";
    };

    public shared (_msg) func registerNode(id : Text, ip : Text) : async Text {
        let node = Nodes.newNode(_msg.caller, id, ip);
        nodes := Array.append(nodes, [node]);
        auditLogs := Audit.log(auditLogs, "Node registered: " # id);
        "✅ Node registered";
    };

    public shared (_msg) func updateNodeStatus(id : Text, status : Text) : async Text {
        nodes := Nodes.updateNodeStatus(nodes, id, status);
        auditLogs := Audit.log(auditLogs, "Node status updated: " # id # " → " # status);
        "✅ Node updated";
    };

    public query func listNodes() : async [Nodes.Node] {
        nodes;
    };

    public shared (_msg) func deregisterNode(id : Text) : async Text {
        nodes := Nodes.removeNode(nodes, id);
        auditLogs := Audit.log(auditLogs, "Node removed: " # id);
        "✅ Node removed";
    };

    public shared (_msg) func reportThreat(nodeId : Text, desc : Text) : async Text {
        let threat = Threats.newThreat(_msg.caller, nodeId, desc);
        threats := Array.append(threats, [threat]);
        auditLogs := Audit.log(auditLogs, "Threat reported: " # nodeId);
        "✅ Threat reported";
    };

    public query func getThreats() : async [Threats.Threat] {
        threats;
    };

    public query func getAudit() : async [Text] {
        auditLogs;
    };

    public shared (_msg) func registerUser(username : Text) : async Text {
        let user = Users.newUser(_msg.caller, username);
        users := Array.append(users, [user]);
        auditLogs := Audit.log(auditLogs, "User registered: " # username);
        "✅ User registered";
    };

    public query func listUsers() : async [Users.User] {
        users;
    };

};
