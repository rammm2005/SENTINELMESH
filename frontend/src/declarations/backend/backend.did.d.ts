import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface Node {
  'id' : string,
  'ip' : string,
  'status' : string,
  'owner' : Principal,
}
export interface Threat {
  'nodeId' : string,
  'description' : string,
  'reporter' : Principal,
}
export interface User { 'principal' : Principal, 'username' : string }
export interface _SERVICE {
  'deregisterNode' : ActorMethod<[string], string>,
  'getAudit' : ActorMethod<[], Array<string>>,
  'getThreats' : ActorMethod<[], Array<Threat>>,
  'hello' : ActorMethod<[], string>,
  'listNodes' : ActorMethod<[], Array<Node>>,
  'listUsers' : ActorMethod<[], Array<User>>,
  'registerNode' : ActorMethod<[string, string], string>,
  'registerUser' : ActorMethod<[string], string>,
  'reportThreat' : ActorMethod<[string, string], string>,
  'updateNodeStatus' : ActorMethod<[string, string], string>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
