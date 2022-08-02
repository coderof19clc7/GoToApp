"use strict";
exports.__esModule = true;
var firebaseApp = require("./firebase/firebaseApp");
var database_1 = require("firebase-admin/database");
var account_1 = require("./account");
firebaseApp.initialize();
var db = (0, database_1.getDatabase)();
console.log("Listening");
db.ref("newUser").on("value", handleData, handleError);
function handleData(snapshot) {
    var _a;
    var val = snapshot.val();
    if (!val)
        return;
    console.log(val);
    try {
        var newAccount = new account_1.Account(val.username, val.phoneNumber, val.password, account_1.AccountType.Customer);
        db.ref("registeredUser").set({
            username: val.username,
            successful: true
        });
    }
    catch (error) {
        handleError(String(error));
        db.ref("registeredStatus").set({
            username: (_a = val.username) !== null && _a !== void 0 ? _a : "",
            successful: false,
            error: String(error)
        });
    }
}
function handleError(error) {
    console.error("\x1b[31m%s\x1b[0m", error);
}
