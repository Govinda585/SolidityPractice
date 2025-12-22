// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

//Write a payable function that accepts Ether and tracks balance.

contract EtherVault {
    uint256 public totalBalance;
    mapping(address => uint256) balanceOf;

    event Deposited(
        address indexed by,
        uint256 amount,
        uint256 newUserBalance,
        uint256 newTotalBalance
    );

    event Withdrawn(
        address indexed by,
        uint256 amount,
        uint256 remainingUserBalance
    );

    function deposit() public payable {
        require(msg.value > 0, "Must send Ether");
        balanceOf[msg.sender] += msg.value;
        totalBalance += msg.value;
        emit Deposited(
            msg.sender,
            msg.value,
            balanceOf[msg.sender],
            totalBalance
        );
    }

    function withdraw() public {
        uint256 amount = balanceOf[msg.sender];
        require(amount > 0, "No balance to withdraw");
        // Update state BEFORE external call (reentrancy safe!)
        balanceOf[msg.sender] = 0;
        totalBalance -= amount;
        emit Withdrawn(msg.sender, amount, 0);
        // External call
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

    function withdrawAmount(uint256 _amount) public {
        require(_amount > 0, "Amount must be > 0");
        require(_amount <= balanceOf[msg.sender], "Insufficent Balance");
        balanceOf[msg.sender] -= _amount;
        totalBalance -= _amount;
        emit Withdrawn(msg.sender, _amount, balanceOf[msg.sender]);

        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transfer failed");
    }
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Accept direct eth
    receive() external payable {}
    // Accept eth with data
    fallback() external payable {
        deposit();
    }
}
