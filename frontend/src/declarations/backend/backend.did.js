export const idlFactory = ({ IDL }) => {
  const Threat = IDL.Record({
    'nodeId' : IDL.Text,
    'description' : IDL.Text,
    'reporter' : IDL.Principal,
  });
  const Node = IDL.Record({
    'id' : IDL.Text,
    'ip' : IDL.Text,
    'status' : IDL.Text,
    'owner' : IDL.Principal,
  });
  const User = IDL.Record({
    'principal' : IDL.Principal,
    'username' : IDL.Text,
  });
  return IDL.Service({
    'deregisterNode' : IDL.Func([IDL.Text], [IDL.Text], []),
    'getAudit' : IDL.Func([], [IDL.Vec(IDL.Text)], ['query']),
    'getThreats' : IDL.Func([], [IDL.Vec(Threat)], ['query']),
    'hello' : IDL.Func([], [IDL.Text], ['query']),
    'listNodes' : IDL.Func([], [IDL.Vec(Node)], ['query']),
    'listUsers' : IDL.Func([], [IDL.Vec(User)], ['query']),
    'registerNode' : IDL.Func([IDL.Text, IDL.Text], [IDL.Text], []),
    'registerUser' : IDL.Func([IDL.Text], [IDL.Text], []),
    'reportThreat' : IDL.Func([IDL.Text, IDL.Text], [IDL.Text], []),
    'updateNodeStatus' : IDL.Func([IDL.Text, IDL.Text], [IDL.Text], []),
  });
};
export const init = ({ IDL }) => { return []; };
