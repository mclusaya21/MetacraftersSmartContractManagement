// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//import "hardhat/console.sol";

contract Lusaya {
    address payable public owner;
    uint256 public balance;

    // Event emitted when a deposit is made
    event DepositFunds(uint256 amount);
    // Event emitted when a withdrawal is made
    event WithdrawFunds(uint256 amount);

    event OwnerTransfer(address indexed previousOwner, address indexed newOwner);
    // Custom error for insufficient balance
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);
    // Custom error for unauthorized withdrawal
    error UnauthorizedWithdrawal(address sender);

    // Constructor sets the initial balance and the owner
    constructor(uint256 initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
    }

    // Function to get the current balance
    function getBalance() public view returns (uint256) {
        return balance;
    }

    // Function to deposit ether into the contract
    function depositFunds() public payable {
        uint256 _amount = msg.value;
        uint256 _previousBalance = balance;

        // Perform transaction
        balance += _amount;

        // Assert transaction completed successfully
        assert(balance == _previousBalance + _amount);

        // Emit the event
        emit DepositFunds(_amount);
    }

    // Function to withdraw a specified amount of ether from the contract
    function withdrawFunds(uint256 _withdrawAmount) public {
        require(msg.sender == owner, "Only the owner can withdraw funds");

        uint256 _previousBalance = balance;
        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }

        // Update balance before transferring to prevent reentrancy attacks
        balance -= _withdrawAmount;

        // Transfer ether to the owner
        (bool success, ) = owner.call{value: _withdrawAmount}("");
        require(success, "Transfer failed");

        // Assert the balance is correct
        assert(balance == (_previousBalance - _withdrawAmount));

        // Emit the event
        emit WithdrawFunds(_withdrawAmount);
    }

   // Function to transfer ownership to a new owner
    function transferOwner(address newOwner) public {
        require(msg.sender == owner, "Only the owner can transfer ownership");
        require(newOwner != address(0), "Invalid new owner address");

        address previousOwner = owner;
        owner = payable(newOwner);

        emit OwnerTransfer(previousOwner, newOwner);
    }
    // Fallback function to receive ether
    receive() external payable {
        depositFunds();
    }

    fallback() external payable {
        depositFunds();
    }
}