//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/console.sol";

contract MetaMultisigWallet {
    //==============
    //==== Errors
    //===============
    error MetaMultisigWallet__NoZeroAddress();
    error MetaMultisigWallet__AmountCannotBeZero();
    error MetaMultisigWallet__TransferError();
    error MetaMultisigWallet__NotEnoughBalance();

    //==============
    //==== Events
    //===============
    event SignerAdded(address indexed who, uint256 newReqSigners);
    event SignerRemoved(address indexed who, uint256 newReqSigners);

    //==============
    //==== State variables
    //===============
    mapping(address owner => bool isActive) public s_owners; // address user => is
    uint256 public s_numRequiredSigners;
    uint256 public s_ownersLength;
    uint256 public s_nonce;

    //==============
    //==== Structs
    //===============

    //==============
    //==== Modifiers
    //===============
    modifier onlySelf() {
        require(msg.sender == address(this), "Only can be executed by self contract");
        _;
    }

    /**
     * @param owners Initial owners of multisigWallet.
     * @param requiredSigners Number of minimum required signatures to execute a tx.
     */
    constructor(address[] memory owners, uint256 requiredSigners) {
        for (uint256 i = 0; i < owners.length; i++) {
            s_owners[owners[i]] = true;
            s_ownersLength++;
            emit SignerAdded(owners[i], requiredSigners);
        }
        s_numRequiredSigners = requiredSigners;
        s_nonce = 0;
    }

    //==============
    //==== External Functions
    //===============

    receive() external payable { }

    /**
     * Create a tx request to add a new signer.
     * @param who New signer in.
     * @param newRequiredSigners New required signers to approve a tx.
     */
    function addSigner(address who, uint256 newRequiredSigners) public {
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
    function removeSigner(address who, uint256 newRequiredSigners) public {
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
    function transferFunds(address to, uint256 amount) public {
        if (to == address(0)) {
            revert MetaMultisigWallet__NoZeroAddress();
        }
        if (amount == 0) {
            revert MetaMultisigWallet__AmountCannotBeZero();
        }
        if (address(this).balance <= amount) {
            revert MetaMultisigWallet__NotEnoughBalance();
        }

        (bool success,) = to.call{ value: amount }("");
        if (!success) {
            revert MetaMultisigWallet__TransferError();
        }
    }

    //  addSigner(address,uint256)
    //  0x5DB21C9aa77fC9393B8da1185C8dEEB7F31EC664
    //  1
    // =====> 0x815c4c880000000000000000000000005db21c9aa77fc9393b8da1185c8deeb7f31ec6640000000000000000000000000000000000000000000000000000000000000001

    function executeTransaction(bytes memory callData, uint256 amount, bytes[] memory signatures) external {
        // TODO: Check signatures if are valid.

        (bool success,) = address(this).call(callData);
        if (!success) revert MetaMultisigWallet__TransferError();
        s_nonce++;
    }

    function getHash(string memory funcName, address user, uint256 argument) external pure returns (bytes memory) {
        return abi.encodeWithSignature(funcName, user, argument);
    }

    /**
     * Check if owner is active or not.
     * @param owner Owner address
     */
    function isOwnerActive(address owner) external view returns (bool) {
        return s_owners[owner];
    }
}
