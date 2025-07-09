import React from "react";

export default function Audit({ audit }) {
    return (
        <div>
            <h2>📝 Audit Logs</h2>
            <ul>
                {audit.map((a, i) => (
                    <li key={i}>{a}</li>
                ))}
            </ul>
        </div>
    );
}
