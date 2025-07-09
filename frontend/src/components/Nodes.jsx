import React, { useState } from "react";
import { backend } from "../declarations/backend";

export default function Nodes({ nodes, refresh }) {
    const [id, setId] = useState("");
    const [ip, setIp] = useState("");

    const registerNode = async () => {
        await backend.registerNode(id, ip);
        setId(""); setIp("");
        refresh();
    };

    return (
        <div>
            <h2>📄 Nodes</h2>
            <ul>
                {nodes.map((n, i) => (
                    <li key={i}>{n.id} ({n.ip}) – {n.status} – Owner: {n.owner.toText()}</li>
                ))}
            </ul>
            <input placeholder="Node ID" value={id} onChange={(e) => setId(e.target.value)} />
            <input placeholder="Node IP" value={ip} onChange={(e) => setIp(e.target.value)} />
            <button onClick={registerNode}>Register Node</button>
        </div>
    );
}
