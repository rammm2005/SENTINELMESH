import React, { useEffect, useState } from "react";
import { AuthClient } from "@dfinity/auth-client";

export default function Auth({ principal, setPrincipal }) {
    const [authClient, setAuthClient] = useState(null);

    const identityProvider = import.meta.env.VITE_IDENTITY_PROVIDER_LOCAL;

    useEffect(() => {
        AuthClient.create().then(async (client) => {
            setAuthClient(client);
            if (await client.isAuthenticated()) {
                setPrincipal(client.getIdentity().getPrincipal().toText());
            }
        });
    }, [setPrincipal]);

    const login = async () => {
        await authClient.login({
            identityProvider,
            onSuccess: () => {
                setPrincipal(authClient.getIdentity().getPrincipal().toText());
            },
        });
    };

    const logout = async () => {
        await authClient.logout();
        setPrincipal(null);
    };

    if (!authClient) return <p>Loading auth…</p>;

    return principal ? (
        <div>
            ✅ Logged in as: {principal} <button onClick={logout}>Logout</button>
        </div>
    ) : (
        <button onClick={login}>Login with ICP</button>
    );
}
