// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Lusaya {
    address payable public owner;
    uint256 public contractBalance;

    event FundsDeposited(uint256 amount);
    event FundsWithdrawn(uint256 amount);

    constructor(uint256 initialBalance) payable {
        owner = payable(msg.sender);
        contractBalance = initialBalance;
    }

    function getContractBalance() external view returns (uint256) {
        return contractBalance;
    }

    function addFunds(uint256 amount) external payable {
        require(msg.sender == owner, "Only the contract owner can deposit funds");
        uint256 previousBalance = contractBalance;

        contractBalance += amount;

        assert(contractBalance == previousBalance + amount);

        emit FundsDeposited(amount);
    }

    error InsufficientFunds(uint256 currentBalance, uint256 requestedAmount);

    function withdrawFunds(uint256 amount) external {
        require(msg.sender == owner, "Only the contract owner can withdraw funds");
        uint256 previousBalance = contractBalance;

        if (contractBalance < amount) {
            revert InsufficientFunds({
                currentBalance: contractBalance,
                requestedAmount: amount
            });
        }

        contractBalance -= amount;

        assert(contractBalance == previousBalance - amount);

        emit FundsWithdrawn(amount);
    }
}