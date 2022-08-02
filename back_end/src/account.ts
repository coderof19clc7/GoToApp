import * as bcrypt from "bcrypt";

export enum AccountType
{
    Customer = "customer",
    Driver = "driver",
    Admin = "admin",
}

export class Account 
{
    username: string;
    phoneNumber: string;
    password: string;
    type: AccountType;

    constructor(username: string, phoneNumber: string, password: string, accountType: AccountType)
    {
        this.username = username;
        this.phoneNumber = phoneNumber;
        this.password = bcrypt.hashSync(password, 5),
        this.type = accountType;
    }
}