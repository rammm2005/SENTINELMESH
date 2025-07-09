import React from "react";

export default function Threats({ threats }) {
    return (
        <div>
            <h2>⚠️ Threats</h2>
            <ul>
                {threats.map((t, i) => (
                    <li key={i}>{t.nodeId} – {t.description} – Reporter: {t.reporter.toText()}</li>
                ))}
            </ul>
        </div>
    );
}
