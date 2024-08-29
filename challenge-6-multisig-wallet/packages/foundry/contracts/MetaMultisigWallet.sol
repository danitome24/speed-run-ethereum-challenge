//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract MetaMultisigWallet is Ownable {
    /**
     *
     * @param owners Owners than will be able to propose, sign and execute tx.
     * @param requiredSign Number of minimum required signatures to execute a tx.
     */
    constructor(address[] memory owners, uint256 requiredSign) Ownable(msg.sender) { }
}
