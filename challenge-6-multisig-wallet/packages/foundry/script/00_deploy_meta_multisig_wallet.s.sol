//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/MetaMultisigWallet.sol";
import "./DeployHelpers.s.sol";

contract DeployMetaMultisigWallet is ScaffoldETHDeploy {
    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();
        vm.startBroadcast(deployerPrivateKey);

        address owner = 0x97289b9C7AE16114D993057F81f99457224a59b3;
        uint256 requiredSigners = 1;

        MetaMultisigWallet multisig = new MetaMultisigWallet(owner, requiredSigners);
        console.logString(
            string.concat("YourContract deployed at: ", vm.toString(address(multisig)))
        );
        vm.stopBroadcast();
    }
}
