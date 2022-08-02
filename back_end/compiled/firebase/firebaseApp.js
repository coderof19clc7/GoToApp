"use strict";
exports.__esModule = true;
exports.initialize = void 0;
var app_1 = require("firebase-admin/app");
var hasInitilized = false;
function initialize() {
    var _a;
    if (hasInitilized)
        return;
    var credential;
    (0, app_1.initializeApp)({
        credential: (0, app_1.cert)(JSON.parse((_a = process.env.SERVICE_ACCOUNT) !== null && _a !== void 0 ? _a : "")),
        databaseURL: process.env.DATABASE_URL
    });
    hasInitilized = true;
}
exports.initialize = initialize;
