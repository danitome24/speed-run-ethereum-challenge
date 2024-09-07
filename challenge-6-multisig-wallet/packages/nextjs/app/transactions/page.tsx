"use client";

import { type FC, useEffect, useState } from "react";
import type { NextPage } from "next";
import { CreateTransaction, TransactionsList } from "./_components";
import { AddressInput, EtherInput, InputBase } from "~~/components/scaffold-eth";


const Transactions: NextPage = () => {

    return (
        <>
            <div className="text-center mt-8 bg-secondary p-6">
                <h1 className="text-4xl my-0">Transactions</h1>
                <p className="text-neutral">
                    Select a type of transaction to create and wait for other signers to validate it.
                    <br />Then it will be executed automatically
                </p>
            </div>
            <TransactionsList />
            <CreateTransaction />
        </>
    );
};

export default Transactions;
