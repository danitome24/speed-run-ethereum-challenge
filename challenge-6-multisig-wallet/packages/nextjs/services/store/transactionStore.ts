import { create } from 'zustand';
import { TransactionType } from '~~/app/transactions/_components';


type TransactionState = {
    transactions: TransactionType[];
    addTransaction: (transaction: TransactionType) => void;
    addSignature: (nonce: number, signature: `0x${string}`) => void;
    setExecuted: (nonce: number) => void;
}

export const useTransactionStore = create<TransactionState>(
    set => ({
        transactions: [],

        addTransaction: (transaction) =>
            set((state) => ({
                transactions: [...state.transactions, transaction],
            })),
        addSignature: (id, signature) =>
            set((state) => ({
                transactions: state.transactions.map(transaction =>
                    transaction.id === id
                        ? {
                            ...transaction,
                            signatures: [...(transaction.signatures || []), signature]
                        }
                        : transaction
                ),
            })),
        setExecuted: (id) =>
            set((state) => ({
                transactions: state.transactions.map(transaction =>
                    transaction.id === id
                        ? { ...transaction, executed: true }
                        : transaction
                ),
            })),
    }),
);
