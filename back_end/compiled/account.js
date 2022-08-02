"use strict";
exports.__esModule = true;
exports.Account = exports.AccountType = void 0;
var bcrypt = require("bcrypt");
var AccountType;
(function (AccountType) {
    AccountType["Customer"] = "customer";
    AccountType["Driver"] = "driver";
    AccountType["Admin"] = "admin";
})(AccountType = exports.AccountType || (exports.AccountType = {}));
var Account = /** @class */ (function () {
    function Account(username, phoneNumber, password, accountType) {
        this.username = username;
        this.phoneNumber = phoneNumber;
        this.password = bcrypt.hashSync(password, 5),
            this.type = accountType;
    }
    return Account;
}());
exports.Account = Account;
