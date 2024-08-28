import { Voucher } from "./Guru";
import { Signature } from "ethers";
import humanizeDuration from "humanize-duration";
import { Address } from "viem";
import { useScaffoldReadContract, useScaffoldWriteContract } from "~~/hooks/scaffold-eth";
import { useEffect } from "react";

type CashOutVoucherButtonProps = {
  clientAddress: Address;
  challenged: Address[];
  closed: Address[];
  voucher: Voucher;
};

export const CashOutVoucherButton = ({ clientAddress, challenged, closed, voucher }: CashOutVoucherButtonProps) => {
  const { writeContractAsync } = useScaffoldWriteContract("Streamer");

  async function autoWithdrawEarningsOnChallenged(voucher) {
    await writeContractAsync({
      functionName: "withdrawEarnings",
      // TODO: change when viem will implement splitSignature
      args: [{ ...voucher, sig: voucher?.signature ? (Signature.from(voucher.signature) as any) : undefined }],
    });
  }

  const { data: timeLeft } = useScaffoldReadContract({
    contractName: "Streamer",
    functionName: "timeLeft",
    args: [clientAddress],
    watch: true,
  });

  const isButtonDisabled =
    !voucher || closed.includes(clientAddress) || (challenged.includes(clientAddress) && !timeLeft);

  useEffect(() => {
    if (challenged.includes(clientAddress)) {
      autoWithdrawEarningsOnChallenged(voucher);
    }
  }, [challenged, clientAddress]);

  return (
    <div className="w-full flex flex-col items-center">
      <div className="h-8 pt-2">
        {challenged.includes(clientAddress) &&
          <span> This channel was challenged, auto withdraw done!
          </span>}
      </div>
      {/*<button
        className={`mt-3 btn btn-primary${challenged.includes(clientAddress) ? " btn-error" : ""}${isButtonDisabled ? " btn-disabled" : ""
          }`}
        disabled={isButtonDisabled}
        onClick={async () => {
          try {
            await writeContractAsync({
              functionName: "withdrawEarnings",
              // TODO: change when viem will implement splitSignature
              args: [{ ...voucher, sig: voucher?.signature ? (Signature.from(voucher.signature) as any) : undefined }],
            });
          } catch (err) {
            console.error("Error calling withdrawEarnings function");
          }
        }}
      >
        Cash out latest voucher
      </button>*/}
    </div>
  );
};
