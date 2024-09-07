import { TransactionType } from "./CreateTransaction";
import { useScaffoldWriteContract } from "~~/hooks/scaffold-eth";
import { useWalletClient } from 'wagmi';
import { useTransactionStore } from "~~/services/store/transactionStore";

export const TransactionRow = ({ tx }: { tx: TransactionType }) => {
    const { writeContractAsync: writeMetaMultisigAsync } = useScaffoldWriteContract("MetaMultisigWallet");
    const { data: walletClient } = useWalletClient();
    // const addSignature = useTransactionStore(state => state.addSignature);
    const updateTransaction = useTransactionStore(state => state.updateTransaction);

    const handleSign = async (tx: TransactionType) => {
        const signature: any = await walletClient?.signMessage({
            message: { raw: tx.callData as `0x${string}` }
        });

        tx.signatures.push(signature);
        updateTransaction(tx.id, tx);
    }

    const handleExec = async (tx: TransactionType) => {
        await writeMetaMultisigAsync({
            functionName: "executeTransaction",
            args: [tx.callData, BigInt(0), []]
        });

        // setExecuted(tx.id);
    }

    return (
        <tr>
            <td className="text-center">{tx.id}</td>
            <td className="text-center">{tx.function}</td>
            <td className="text-center"> {tx.signatures?.length || 0} / {tx.requiredSigners}</td>
            <td>
                <button className="btn btn-secondary btn-sm self-end md:self-start" onClick={() => handleSign(tx)}>Sign</button>
                {tx.signatures?.length === tx.requiredSigners ?
                    <button className="btn btn-secondary btn-sm self-end md:self-start" onClick={() => handleExec(tx)}>Execute</button>
                    : <button className="btn btn-secondary btn-sm self-end md:self-start btn-disabled" onClick={() => handleExec(tx)}>Execute</button>}
            </td>
        </tr>
    )
}

export default TransactionRow;
