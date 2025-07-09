import React, { useState } from "react";
import { backend } from "../declarations/backend";

export default function Users({ users, refresh }) {
    const [username, setUsername] = useState("");

    const registerUser = async () => {
        await backend.registerUser(username);
        setUsername("");
        refresh();
    };

    return (
        <div>
            <h2>👤 Users</h2>
            <ul>
                {users.map((u, i) => (
                    <li key={i}>{u.username} – {u.principal.toText()}</li>
                ))}
            </ul>
            <input placeholder="Username" value={username} onChange={(e) => setUsername(e.target.value)} />
            <button onClick={registerUser}>Register User</button>
        </div>
    );
}
