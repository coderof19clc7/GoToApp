import { initializeApp, cert } from "firebase-admin/app";

var hasInitilized = false;

export function initialize()
{
    if (hasInitilized)
        return;

    let credential: Credential;

    initializeApp({
        credential: cert(JSON.parse(process.env.SERVICE_ACCOUNT ?? "")),
        databaseURL: process.env.DATABASE_URL
    })

    hasInitilized = true;
}