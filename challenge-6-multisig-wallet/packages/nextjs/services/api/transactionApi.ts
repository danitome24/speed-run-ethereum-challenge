import { TransactionType } from "~~/app/transactions/_components";

export async function saveTransaction(tx: TransactionType) {
    await fetch('/api/transactions', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(
            tx,
            (key, value) => (typeof value === "bigint" ? value.toString() : value),
        ),
    });
}

export async function getTransactions() {
    const txs = await fetch('/api/transactions', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        },
    });

    return await txs.json();
}
