// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

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

    event SignerAdded(address, uint256);
    event SignerRemoved(address, uint256);

    function testCanAddNewSigner() public {
        uint256 previousLength = multisigWallet.s_ownersLength();
        address newSigner = makeAddr("New");
        uint256 newRequiredSigners = 3;
        vm.expectEmit(true, true, true, false);

        emit SignerAdded(newSigner, newRequiredSigners);
        multisigWallet.addSigner(newSigner, newRequiredSigners);

        assertEq(multisigWallet.s_ownersLength(), previousLength + 1);
        assertEq(multisigWallet.isOwnerActive(newSigner), true);
    }

    function testShouldFailIfNewSignerIsAddressZero() public {
        address newSigner = address(0);
        uint256 newRequiredSigners = 3;

        vm.expectRevert(MetaMultisigWallet.MetaMultisigWallet__NoZeroAddress.selector);
        multisigWallet.addSigner(newSigner, newRequiredSigners);
    }

    function testCanRemoveSigner() public {
        uint256 newRequiredSigners = 2;
        vm.expectEmit(true, true, true, false);

        emit SignerRemoved(ownerThree, newRequiredSigners);
        multisigWallet.removeSigner(ownerThree, newRequiredSigners);

        assertEq(multisigWallet.isOwnerActive(ownerThree), false);
    }
}
