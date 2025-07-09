import React, { useEffect, useState } from "react";
import { backend } from "./declarations/backend";
import Auth from "./components/Auth";
import Nodes from "./components/Nodes";
import Users from "./components/Users";
import Threats from "./components/Threats";
import Audit from "./components/Audit";

export default function App() {
  const [message, setMessage] = useState("");
  const [nodes, setNodes] = useState([]);
  const [users, setUsers] = useState([]);
  const [threats, setThreats] = useState([]);
  const [audit, setAudit] = useState([]);

  const [principal, setPrincipal] = useState(null);

  const sayHello = async () => {
    const res = await backend.hello();
    setMessage(res);
  };

  const loadData = async () => {
    const [n, u, t, a] = await Promise.all([
      backend.listNodes(),
      backend.listUsers(),
      backend.getThreats(),
      backend.getAudit(),
    ]);
    setNodes(n);
    setUsers(u);
    setThreats(t);
    setAudit(a);
  };

  useEffect(() => {
    sayHello();
    loadData();
  }, []);

  return (
    <div style={{ padding: "2rem", fontFamily: "Arial" }}>
      <h1>SentinelMesh 🌐</h1>
      <p>{message}</p>

      <Auth principal={principal} setPrincipal={setPrincipal} />

      <Nodes nodes={nodes} refresh={loadData} />
      <Users users={users} refresh={loadData} />
      <Threats threats={threats} />
      <Audit audit={audit} />
    </div>
  );
}
