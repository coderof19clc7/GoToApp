import * as firebaseApp from "./firebaseApp";
import { DocumentReference, getFirestore, Query, QuerySnapshot } from "firebase-admin/firestore";

firebaseApp.initialize();

const firestore = getFirestore();

export function collection(collectionPath: string) 
{
    return firestore.collection(collectionPath);
}

export async function query(query: Query) 
{
    let snapshot = await query.get();
    return snapshotToData(snapshot);
}

export function snapshotToData(snapshot: QuerySnapshot) 
{
    let result: any[] = [];

    snapshot.forEach((doc) => {
        let data = doc.data();
        data.id = doc.id;
        result.push(data);
    })

    return result;
}

export async function update(ref: DocumentReference, data: any) 
{
    return await ref.set(data);
}