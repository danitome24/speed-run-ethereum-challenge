// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { MetaMultisigWallet } from "../contracts/MetaMultisigWallet.sol";

contract MetaMultisigWalletTest is Test {
    uint256 constant INITIAL_REQUIRED_SIGNERS = 2;

    MetaMultisigWallet multisigWallet;
    address ownerOne = makeAddr("Owner1");
    address ownerTwo = makeAddr("Owner2");
    address ownerThree = makeAddr("Owner3");

    function setUp() external {
        address[] memory owners = new address[](3);
        owners[0] = ownerOne;
        owners[1] = ownerTwo;
        owners[2] = ownerThree;
        multisigWallet = new MetaMultisigWallet(owners, INITIAL_REQUIRED_SIGNERS);
    }

    event SignerAdded(uint256, address, uint256);

    function testCanAddNewSigner() public {
        address newSigner = makeAddr("New");
        uint256 newRequiredSigners = 3;
        vm.expectEmit(true, true, true, false);

        emit SignerAdded(0, newSigner, newRequiredSigners);
        multisigWallet.addSigner(newSigner, newRequiredSigners);
    }

    function testShouldFailIfNewSignerIsAddressZero() public {
        address newSigner = address(0);
        uint256 newRequiredSigners = 3;

        vm.expectRevert(MetaMultisigWallet.MetaMultisigWallet__NoZeroAddress.selector);
        multisigWallet.addSigner(newSigner, newRequiredSigners);
    }
}
