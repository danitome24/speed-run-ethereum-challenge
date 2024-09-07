import { Signature, TransactionType } from "~~/types/transaction";
import { useScaffoldWriteContract } from "~~/hooks/scaffold-eth";
import { useAccount, useWalletClient } from 'wagmi';
import { useTransactionStore } from "~~/services/store/transactionStore";
import { useScaffoldReadContract } from "~~/hooks/scaffold-eth";

export const TransactionRow = ({ tx }: { tx: TransactionType }) => {
    const { writeContractAsync: writeMetaMultisigAsync } = useScaffoldWriteContract("MetaMultisigWallet");
    const { data: walletClient } = useWalletClient();
    const { address: sender } = useAccount();
    if (sender == undefined) {
        return;
    }

    const { data: isOwner } = useScaffoldReadContract({
        contractName: "MetaMultisigWallet",
        functionName: "isOwnerActive",
        args: [sender],
    });
    // const addSignature = useTransactionStore(state => state.addSignature);
    const updateTransaction = useTransactionStore(state => state.updateTransaction);

    const handleSign = async (tx: TransactionType) => {
        const sign: any = await walletClient?.signMessage({
            message: { raw: tx.callData as `0x${string}` }
        });
        const signatureObject: Signature = {
            signature: sign,
            address: sender
        }

        tx.signatures.push(signatureObject);
        updateTransaction(tx.id, tx);

    }

    const handleExec = async (tx: TransactionType) => {
        await writeMetaMultisigAsync({
            functionName: "executeTransaction",
            args: [tx.callData, BigInt(0), []]
        });

        // setExecuted(tx.id);
    }

    const hasAlreadySigned = (transaction: TransactionType, address: `0x${string}`): boolean => {
        return transaction.signatures.some(signature => signature.address === address);
    }

    return (
        <tr>
            <td className="text-center">{tx.id}</td>
            <td className="text-center">{tx.function}</td>
            <td className="text-center">{tx.signatures?.length || 0} / {tx.requiredSigners}</td>
            <td className="flex flex-col md:flex-row gap-2">
                {isOwner ? (
                    <>
                        <button className={`btn btn-secondary btn-sm ${hasAlreadySigned(tx, sender) ? 'btn-disabled' : ''}`} onClick={() => handleSign(tx)}>
                            {hasAlreadySigned(tx, sender) ? 'Signed 👌 ' : 'Sign'}
                        </button>
                        <button
                            className={`btn btn-secondary btn-sm ${tx.signatures?.length === tx.requiredSigners ? '' : 'btn-disabled'}`}
                            onClick={() => handleExec(tx)}
                            disabled={tx.signatures?.length !== tx.requiredSigners}>
                            Execute
                        </button>
                    </>
                ) : (
                    <p>No rights 😶 </p>
                )}

            </td>
        </tr>
    )
}

export default TransactionRow;
