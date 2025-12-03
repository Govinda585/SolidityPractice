// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
//Make a contract with a mapping from address to uint balance.

contract BalanceTracker {
    mapping(address => uint) public balanceOf;
    uint public totalSupply;

    event Deposit(address indexed user, uint amount, uint newBalance);
    event Withdrawal(address indexed user, uint amount, uint newBalance);
    event Transfer(address indexed from, address indexed to, uint amount);

    function deposit(address to, uint256 amount) public {
        require(to != address(0), "Zero address");
        require(amount > 0, "Amount must be greater than zero");

        balanceOf[to] += amount;
        totalSupply += amount;

        emit Deposit(to, amount, balanceOf[to]);
    }

    function withdraw(address from, uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf[from] >= amount, "Insufficient balance");

        balanceOf[from] -= amount;
        totalSupply -= amount;

        emit Withdrawal(from, amount, balanceOf[from]);
    }

    function transfer(address to, uint amount) public {
        require(to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
        emit Withdrawal(msg.sender, amount, balanceOf[msg.sender]);
        emit Deposit(to, amount, balanceOf[to]);
    }

    function depositToMyself(uint256 amount) public {
        deposit(msg.sender, amount);
    }
}
