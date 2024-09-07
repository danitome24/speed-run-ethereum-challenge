"use client";

import { type FC, useEffect, useState } from "react";
import type { NextPage } from "next";
import { CreateTransaction, TransactionsList, Banner } from "./_components";
import { AddressInput, EtherInput, InputBase } from "~~/components/scaffold-eth";
import { useScaffoldEventHistory } from "~~/hooks/scaffold-eth";
import { Signer } from "~~/types/transaction";

const Transactions: NextPage = () => {
    const [signers, setSigners] = useState([]);
    const {
        data: events,
        isLoading: isLoadingEvents,
        error: errorReadingEvents,
    } = useScaffoldEventHistory({
        contractName: "MetaMultisigWallet",
        eventName: "SignerAdded",
        fromBlock: 0n,
        watch: true,
        blockData: true,
    });

    useEffect(() => {
        if (events) {
            const newSigners = events.map(event => event.args.who);

            setSigners(newSigners);
        }
    }, [events]);


    return (
        <>
            <Banner />
            <div className="grid grid-cols-4 gap-4">
                <div className="p-12 col-start-1 col-span-2 grid grid-cols-1 gap-8 lg:gap-10">
                    <div className=" col-span-1 lg:col-span-2 flex flex-col gap-6">
                        <div className="z-10">
                            <div className="bg-base-100 rounded-3xl shadow-md shadow-secondary border border-base-300 flex flex-col relative">
                                <div className="p-5 divide-y divide-base-300">
                                    <div className="flex flex-col gap-3 py-5 first:pt-0 last:pb-1">
                                        Owners:
                                        {signers?.length ? (
                                            <ul>
                                                {signers.map((signer, i) => (
                                                    <li key={i}>{signer}</li>
                                                ))}
                                            </ul>
                                        ) : (
                                            <div className="col-span-4 text-center">
                                                <p>No signers available</p>
                                            </div>
                                        )}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
                <div className="p-12">
                    <TransactionsList />
                </div>
                <div className="p-12 ">
                    <CreateTransaction />
                </div>
            </div>
        </>
    );
};

export default Transactions;
