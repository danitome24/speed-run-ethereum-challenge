pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {YourToken} from "./YourToken.sol";

contract Vendor is Ownable {
    ////
    // Errors
    ////
    error Vendor__CannotBuyZeroTokens();
    error Vendor__WithdrawFailed();

    ////
    // Event
    ////
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    ////
    // State Variables
    ////
    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        if (msg.value == 0) {
            revert Vendor__CannotBuyZeroTokens();
        }
        uint256 amountTokensToBuy = msg.value * tokensPerEth;

        yourToken.transfer(msg.sender, amountTokensToBuy);
        emit BuyTokens(msg.sender, msg.value, amountTokensToBuy);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        (bool success,) = payable(owner()).call{value: address(this).balance}("");
        if (!success) {
            revert Vendor__WithdrawFailed();
        }
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
}
