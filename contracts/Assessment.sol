// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Lusaya {
    address payable public owner;
    uint256 public balance;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);

    constructor(uint256 initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
    }

    function getBalance() external view returns (uint256) {
        return balance;
    }

    function deposit(uint256 amount) external payable {
        require(msg.sender == owner, "Only the owner can deposit funds");
        uint256 previousBalance = balance;

        balance += amount;

        assert(balance == previousBalance + amount);

        emit Deposit(amount);
    }

    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 withdrawAmount) external {
        require(msg.sender == owner, "Only the owner can deposit funds");
        uint256 previousBalance = balance;

        if (balance < withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: withdrawAmount
            });
        }

        balance -= withdrawAmount;

        assert(balance == previousBalance - withdrawAmount);

        emit Withdraw(withdrawAmount);
    }
}