"use client";

import { type FC, useEffect, useState } from "react";
import type { NextPage } from "next";
import { CreateTransaction, TransactionsList, Banner } from "./_components";
import { AddressInput, EtherInput, InputBase } from "~~/components/scaffold-eth";

const Transactions: NextPage = () => {

    return (
        <>
            <Banner />
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
