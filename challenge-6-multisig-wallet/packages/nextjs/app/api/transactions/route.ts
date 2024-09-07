import { TransactionType } from "~~/app/transactions/_components"

let nextId = 0;
const transactions: TransactionType[] = [];

export async function GET(request: Request) {
    return Response.json(transactions)
}

export async function POST(request: Request) {
    const body = await request.json();
    const newTx = body as TransactionType;
    newTx.id = nextId;
    transactions.push(newTx)
    nextId++;
    return Response.json({ message: "Success" })
}