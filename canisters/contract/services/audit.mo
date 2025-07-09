import Text "mo:base/Text";
import Array "mo:base/Array";

module {
    public func log(logs : [Text], entry : Text) : [Text] {
        return Array.append<Text>(logs, [entry]);
    };
};
