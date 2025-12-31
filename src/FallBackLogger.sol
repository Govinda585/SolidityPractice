// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract FallBackLogger {
    event EthReceived(address indexed by, uint256 amount);

    // Called when msg.data is empty
    receive() external payable {
        emit EthReceived(msg.sender, msg.value);
    }

    // Called when msg.data is not empty
    fallback() external payable {
        emit EthReceived(msg.sender, msg.value);
    }
}
