//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MetaMultisigWallet {
    //==============
    //==== Errors
    //===============
    error MetaMultisigWallet__NoZeroAddress();

    //==============
    //==== Events
    //===============
    event TransactionAddSignerCreated(address, uint256);

    //==============
    //==== State variables
    //===============
    address[] public s_owners;
    uint256 public s_numRequiredSigners;
    uint256 public s_nonce;
    mapping(uint256 => Transaction) public s_transactions;

    //==============
    //==== Structs
    //===============
    struct Transaction {
        uint256 id;
        bytes functionToExecute;
        uint256 numOfSigners;
        bool isExecuted;
    }

    /**
     * @param initialOwner Initial owner of multisigWallet.
     * @param requiredSigners Number of minimum required signatures to execute a tx.
     */
    constructor(address initialOwner, uint256 requiredSigners) {
        s_owners.push(initialOwner);
        s_numRequiredSigners = requiredSigners;
        s_nonce = 0;
    }

    //==============
    //==== External Functions
    //===============

    /**
     * Create a tx request to add a new signer.
     * @param who New signer in.
     * @param newRequiredSigners New required signers to approve a tx.
     */
    function addSigner(address who, uint256 newRequiredSigners) external {
        if (who == address(0)) {
            revert MetaMultisigWallet__NoZeroAddress();
        }
        s_numRequiredSigners = newRequiredSigners;
        bytes memory funcToExecute = abi.encodeWithSignature("addSigner(address,uint256)", who, newRequiredSigners);
        s_transactions[s_nonce] = Transaction({
            id: s_nonce,
            functionToExecute: funcToExecute,
            numOfSigners: newRequiredSigners,
            isExecuted: false
        });
        s_nonce++;
        emit TransactionAddSignerCreated(who, newRequiredSigners);
    }

    /**
     * Create a tx request to remove an existing signer.
     * @param who New signer in.
     * @param newRequiredSigners New required signers to approve a tx.
     */
    function removeSigner(address who, uint256 newRequiredSigners) external { }

    /**
     * Create a tx request to transfer funds.
     * @param to Address who will receive funds.
     * @param amount Amount sent.
     */
    function transferFunds(address to, uint256 amount) external { }

    /**
     * Approves a transaction from signer.
     * @param id Tx request id.
     */
    function signTransaction(uint256 id) external { }

    /**
     * Execute a transaction from signer.
     * @param id Tx request id.
     */
    function executeTransaction(uint256 id) external { }
}
