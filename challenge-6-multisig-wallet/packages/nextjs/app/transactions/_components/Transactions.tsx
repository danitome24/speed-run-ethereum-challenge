import { type FC, useEffect, useState } from "react";
import type { NextPage } from "next";
import TransactionRow from "./TransactionRow";
import { useTransactionStore } from "~~/services/store/transactionStore";

export const TransactionsList: NextPage = () => {

    const transactions = useTransactionStore((state) => state.transactions);
    const fetchTransactions = useTransactionStore((state) => state.fetchTransactions);
console.log(transactions)
    useEffect(() => {
        fetchTransactions();
    }, [fetchTransactions]);

    return (
        <div className="flex flex-col gap-y-6 lg:gap-y-8 py-4 lg:py-12 justify-center items-center">
            <div className="flex flex-row gap-2 w-full max-w-7xl pb-1 px-6 lg:px-10 flex-wrap">
                <div className={`grid grid-cols-1 lg:grid-cols-6 px-6 lg:px-10 lg:gap-12 w-full max-w-7xl my-0`}>
                    <div className="col-start-1 col-span-6 grid grid-cols-1 gap-8 lg:gap-10">
                        <div className=" col-span-1 lg:col-span-2 flex flex-col gap-6">
                            <div className="z-10">
                                <div className="bg-base-100 rounded-3xl shadow-md shadow-secondary border border-base-300 flex flex-col mt-10 relative">
                                    <div className="p-5 divide-y divide-base-300">
                                        <div className="flex flex-col gap-3 py-5 first:pt-0 last:pb-1">
                                            {transactions?.length ? (
                                                <table className="table-auto">
                                                    <caption className="caption-top">
                                                        Current transactions
                                                    </caption>
                                                    <thead>
                                                        <tr>
                                                            <th className="text-center">ID.</th>
                                                            <th className="text-center">TYPE</th>
                                                            <th className="text-center">SIGNERS</th>
                                                            <th className="text-center"></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        {transactions.map((tx) => (
                                                            <TransactionRow key={crypto.randomUUID()} tx={tx} />
                                                        ))}
                                                    </tbody>
                                                </table>
                                            ) : (
                                                <div>
                                                    <p className={"col-span-4 text-center"}>No transactions available</p>
                                                </div>
                                            )}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}