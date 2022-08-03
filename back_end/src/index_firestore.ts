import * as firestore from "./firebase/firestore";


async function getUser() 
{
    console.log("Getting users");
    let data = await firestore.query(firestore.collection("users"));

    for (let item of data) {
        console.log(item);
    }
}

getUser();