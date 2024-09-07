export type TransactionType = {
    id: number,
    function: string,
    to: `0x${string}`,
    arg: bigint,
    callData?: `0x${string}`,
    signatures: `0x${string}`[],
    requiredSigners: number,
    executed: boolean
}
