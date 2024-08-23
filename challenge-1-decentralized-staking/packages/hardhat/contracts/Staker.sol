// SPDX-License-Identifier: MIT
pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
    ////
    //  ERRORS
    ////
    error Staker__NotEnoughEthSent();
    error Staker__DeadlineHasNotPassedYet();
    error Staker__UnavailableWithdraw();
    error Staker__WithdrawFailed();
    error Staker__NoMoreCallsOnExecute();
    error Staker__DeadlineReached();
    error Staker__AlreadyCompleted();

    ////
    //  Events
    ////
    event Stake(address, uint256);
    event WithdrawSuccess(address);
    event ExternalContractCompleted(uint256);

    ////
    //  Constants
    ////
    uint256 public constant threshold = 1 ether;

    ////
    //  State variables
    ////
    mapping(address => uint256) public balances;
    ExampleExternalContract public immutable exampleExternalContract;
    uint256 public immutable deadline;
    bool public s_openForWithdraw = false;
    bool public s_canCallExecute = true;

    ////
    //  Functions
    ////
    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
        deadline = block.timestamp + 72 hours;
    }

    // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
    // (Make sure to add a `Stake(address,uint256)` event and emit it for the frontend `All Stakings` tab to display)
    function stake() public payable notCompleted {
        if (msg.value <= 0) {
            revert Staker__NotEnoughEthSent();
        }
        if (block.timestamp >= deadline) {
            revert Staker__DeadlineReached();
        }
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }

    // After some `deadline` allow anyone to call an `execute()` function
    // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
    function execute() public notCompleted {
        uint256 currentTimestamp = block.timestamp;
        if (currentTimestamp < deadline) {
            revert Staker__DeadlineHasNotPassedYet();
        }

        if (address(this).balance < threshold) {
            s_openForWithdraw = true;
        } else {
            exampleExternalContract.complete{value: address(this).balance}();
            emit ExternalContractCompleted(address(this).balance);
        }
    }

    // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
    function withdraw() public notCompleted {
        if (!s_openForWithdraw) {
            revert Staker__UnavailableWithdraw();
        }

        uint256 amountToTransfer = balances[msg.sender];
        (bool success,) = payable(msg.sender).call{value: amountToTransfer}("");
        emit WithdrawSuccess(msg.sender);

        if (!success) {
            revert Staker__WithdrawFailed();
        }
    }

    // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        }

        return deadline - block.timestamp;
    }

    // Add the `receive()` special function that receives eth and calls stake()
    receive() external payable {
        stake();
    }

    modifier notCompleted() {
        if (exampleExternalContract.completed()) {
            revert Staker__AlreadyCompleted();
        }
        _;
    }
}
