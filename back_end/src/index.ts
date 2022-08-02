import * as firebaseApp from "./firebase/firebaseApp";
import { DataSnapshot, getDatabase } from "firebase-admin/database";
import { AccountType, Account } from "./account";

firebaseApp.initialize();

const db = getDatabase();

console.log("Listening");

db.ref("newUser").on("value", handleData, handleError);

function handleData(snapshot: DataSnapshot)
{
    let val = snapshot.val();

    if (!val)
        return;

    console.log(val);
    
    try {
        let newAccount = new Account(val.username, val.phoneNumber, val.password, AccountType.Customer);
        db.ref("registeredUser").set({
            username: val.username,
            successful: true
        });
    } 
    catch (error) {
        handleError(String(error));
        db.ref("registeredStatus").set({
            username: val.username ?? "",
            successful: false,
            error: String(error)
        });    
    }
}

function handleError(error: any)
{
    console.error("\x1b[31m%s\x1b[0m", error)
}