import * as firebaseApp from "./firebase/firebaseApp";
import { DataSnapshot, getDatabase } from "firebase-admin/database";
import { AccountType, Account } from "./account";
import { handleError } from "./utilities";
import * as firestore from "./firebase/firestore";

firebaseApp.initialize();

const db = getDatabase();

console.log("Listening for new users");

export function enable()
{
    db.ref("newUser").on("value", handleData, handleError);
}

export function disable()
{
    db.ref("newUser").off("value");
}

async function handleData(snapshot: DataSnapshot)
{
    let val = snapshot.val();

    if (!val)
        return;

    console.log("New update")
    console.log(val);
    
    try {
        let newAccount = new Account(val.username, val.phoneNumber, val.password, AccountType.Customer);
        await register(newAccount);
    } 
    catch (error) {
        handleError(String(error));
        db.ref("registerStatus").set({
            username: val.username ?? "",
            successful: false,
            error: String(error)
        });    
    }
}

async function register(newAccount: Account)
{
    await firestore.collection("users").doc().set({ ...newAccount });

    console.log(`Registered user ${newAccount.username}`)
    
    db.ref("registerStatus").set({
        username: newAccount.username,
        successful: true
    });
}