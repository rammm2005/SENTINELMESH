import Text "mo:base/Text";
import Principal "mo:base/Principal";

module {
    public type Threat = {
        nodeId : Text;
        description : Text;
        reporter : Principal;
    };

    public func newThreat(reporter : Principal, nodeId : Text, desc : Text) : Threat {
        {
            nodeId = nodeId;
            description = desc;
            reporter = reporter;
        };
    };
};
