
import type { NextPage } from "next";
import { type FC, useEffect, useState } from "react";
import { FunctionSelector } from "./FunctionSelector";
import { AddressInput, EtherInput, InputBase } from "~~/components/scaffold-eth";

export const CreateTransaction: NextPage = () => {
    const METHODS = ["addSigner", "removeSigner", "transferFunds"];

    const nonce = 0;
    const [funcSelected, setFuncSelected] = useState("");
    const [ethValue, setEthValue] = useState("");
    const [callData, setCallData] = useState("");
    const [signer, setSigner] = useState("");

    const handleCreate = async () => {
        // do stuff with contract.
    }

    return (
        <div className="flex flex-col flex-1 items-center my-20 gap-8">
            <div className="flex items-center flex-col flex-grow w-full max-w-lg">
                <div className="flex flex-col bg-base-100 shadow-lg shadow-secondary border-8 border-secondary rounded-xl w-full p-6">
                    <div>
                        <label className="label">
                            <span className="label-text">Nonce</span>
                        </label>
                        <InputBase
                            disabled
                            value={nonce !== undefined ? `# ${nonce}` : "Loading..."}
                            placeholder={"Loading..."}
                            onChange={() => {
                                null;
                            }}
                        />
                    </div>

                    <div className="flex flex-col gap-4">
                        <div className="mt-6 w-full">
                            <label className="label">
                                <span className="label-text">Select method</span>
                            </label>
                            <select className="select select-bordered select-sm w-full bg-base-200 text-accent font-medium" onChange={(e) => setFuncSelected(e.target.value)}>
                                {METHODS.map(method => (
                                    <option key={method} value={method}>
                                        {method}
                                    </option>
                                ))}
                            </select>
                        </div>

                        <AddressInput
                            placeholder={funcSelected === "transferFunds" ? "Recipient address" : "Signer address"}
                            value={signer}
                            onChange={signer => setSigner(signer)}
                        />

                        {funcSelected === "transferFunds" && (
                            <EtherInput
                                value={ethValue}
                                onChange={val => {
                                    setEthValue(val);
                                }}
                            />
                        )}

                        <InputBase
                            value={callData || ""}
                            placeholder={"Calldata"}
                            onChange={() => {
                                null;
                            }}
                            disabled
                        />

                        <button className="btn btn-secondary btn-sm" onClick={handleCreate}>
                            Create
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
}
