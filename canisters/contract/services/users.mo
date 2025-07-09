import Text "mo:base/Text";
import Principal "mo:base/Principal";

module {
    public type User = {
        username : Text;
        principal : Principal;
    };

    public func newUser(p : Principal, username : Text) : User {
        {
            username = username;
            principal = p;
        };
    };
};
