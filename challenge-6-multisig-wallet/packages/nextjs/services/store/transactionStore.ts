import { create } from 'zustand';
import { TransactionType } from "~~/types/transaction";

type TransactionState = {
    transactions: TransactionType[];
    fetchTransactions: () => Promise<void>;
    addTransaction: (transaction: TransactionType) => Promise<void>;
    updateTransaction: (id: number, updatedData: Partial<TransactionType>) => Promise<void>;
};

export const useTransactionStore = create<TransactionState>((set) => ({
    transactions: [],

    fetchTransactions: async () => {
        const response = await fetch('/api/transactions');
        const data: any[] = await response.json();
        const transactions = data.map((transaction) => ({
            ...transaction,
            arg: BigInt(transaction.arg),
        }));
        set({ transactions });
    },

    addTransaction: async (transaction: TransactionType) => {
        const response = await fetch('/api/transactions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(
                transaction,
                // stringifying bigint
                (key, value) => (typeof value === "bigint" ? value.toString() : value),
            ),
        });
        const newTransaction = await response.json();
        set((state) => ({
            transactions: [...state.transactions, newTransaction],
        }));
    },

    updateTransaction: async (id: number, updatedData: Partial<TransactionType>) => {
        const response = await fetch(`/api/transactions`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(
                updatedData,
                // stringifying bigint
                (key, value) => (typeof value === "bigint" ? value.toString() : value),
            ),
        });
        const updatedTransaction = await response.json();
        set((state) => ({
            transactions: state.transactions.map((transaction) =>
                transaction.id === id ? updatedTransaction : transaction
            ),
        }));
    },
}));
