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
    event SignerAdded(uint256, address, uint256);

    //==============
    //==== State variables
    //===============
    address[] public s_owners;
    uint256 public s_numRequiredSigners;
    uint256 public s_nonce;

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
     * @param owners Initial owners of multisigWallet.
     * @param requiredSigners Number of minimum required signatures to execute a tx.
     */
    constructor(address[] memory owners, uint256 requiredSigners) {
        for (uint256 i = 0; i < owners.length; i++) {
            s_owners.push(owners[i]);
        }
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
        emit SignerAdded(s_nonce, who, newRequiredSigners);
        s_nonce++;
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
    function signTransaction(
        uint256 id
    ) external { }

    /**
     * Execute a transaction from signer.
     * @param id Tx request id.
     */
    function executeTransaction(
        uint256 id
    ) external { }
}
