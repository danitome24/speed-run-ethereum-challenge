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
    event SignerAdded(address, uint256);
    event SignerRemoved(address, uint256);

    //==============
    //==== State variables
    //===============
    mapping(address owner => bool isActive) public s_owners; // address user => is
    uint256 public s_numRequiredSigners;
    uint256 public s_ownersLength;

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
            s_owners[owners[i]] = true;
            s_ownersLength++;
        }
        s_numRequiredSigners = requiredSigners;
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
        s_owners[who] = true;
        emit SignerAdded(who, newRequiredSigners);
        s_ownersLength++;
    }

    /**
     * Create a tx request to remove an existing signer.
     * @param who New signer in.
     * @param newRequiredSigners New required signers to approve a tx.
     */
    function removeSigner(address who, uint256 newRequiredSigners) external {
        if (who == address(0)) {
            revert MetaMultisigWallet__NoZeroAddress();
        }
        s_numRequiredSigners = newRequiredSigners;
        s_owners[who] = false;
        emit SignerRemoved(who, newRequiredSigners);
    }

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

    /**
     * Check if owner is active or not.
     * @param owner Owner address
     */
    function isOwnerActive(address owner) external view returns (bool) {
        return s_owners[owner];
    }
}
