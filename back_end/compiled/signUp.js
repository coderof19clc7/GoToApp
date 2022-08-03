"use strict";
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
exports.__esModule = true;
exports.disable = exports.enable = void 0;
var firebaseApp = require("./firebase/firebaseApp");
var database_1 = require("firebase-admin/database");
var account_1 = require("./account");
var utilities_1 = require("./utilities");
var firestore = require("./firebase/firestore");
firebaseApp.initialize();
var db = (0, database_1.getDatabase)();
console.log("Listening for new users");
function enable() {
    db.ref("newUser").on("value", handleData, utilities_1.handleError);
}
exports.enable = enable;
function disable() {
    db.ref("newUser").off("value");
}
exports.disable = disable;
function handleData(snapshot) {
    var _a;
    return __awaiter(this, void 0, void 0, function () {
        var val, newAccount, error_1;
        return __generator(this, function (_b) {
            switch (_b.label) {
                case 0:
                    val = snapshot.val();
                    if (!val)
                        return [2 /*return*/];
                    console.log(val);
                    _b.label = 1;
                case 1:
                    _b.trys.push([1, 3, , 4]);
                    newAccount = new account_1.Account(val.username, val.phoneNumber, val.password, account_1.AccountType.Customer);
                    return [4 /*yield*/, register(newAccount)];
                case 2:
                    _b.sent();
                    return [3 /*break*/, 4];
                case 3:
                    error_1 = _b.sent();
                    (0, utilities_1.handleError)(String(error_1));
                    db.ref("registeredStatus").set({
                        username: (_a = val.username) !== null && _a !== void 0 ? _a : "",
                        successful: false,
                        error: String(error_1)
                    });
                    return [3 /*break*/, 4];
                case 4: return [2 /*return*/];
            }
        });
    });
}
function register(newAccount) {
    return __awaiter(this, void 0, void 0, function () {
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, firestore.collection("users").doc().set(__assign({}, newAccount))];
                case 1:
                    _a.sent();
                    db.ref("registeredUser").set({
                        username: newAccount.username,
                        successful: true
                    });
                    return [2 /*return*/];
            }
        });
    });
}
