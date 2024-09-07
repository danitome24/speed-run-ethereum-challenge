import { TransactionType } from "~~/app/transactions/_components"

let nextId = 0;
let transactions: TransactionType[] = [
    // {
    //     id: 0,
    //     function: "addSigner",
    //     to: "0x5DB21C9aa77fC9393B8da1185C8dEEB7F31EC664",
    //     arg: BigInt(1),
    //     requiredSigners: 1,
    //     executed: false
    // }
];

export async function GET(request: Request) {
    transactions.map(tx => {

    })
    return Response.json(transactions)
}

export async function POST(request: Request) {
    const body = await request.json();
    const newTx = body as TransactionType;
    newTx.id = nextId;
    transactions.push(newTx)
    nextId++;
    return Response.json(newTx);
}

export async function PUT(request: Request) {
    const body = await request.json();
    const updatedTransaction = body as TransactionType;

    transactions.map(tx => {
        tx.id === updatedTransaction.id ? { ...tx, ...updatedTransaction } : tx
    });

    return Response.json({ message: "Success" })
}