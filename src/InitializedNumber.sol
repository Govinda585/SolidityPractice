// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// Implement a contract with a constructor that sets an initial value.

contract InitializedNumber {
    uint256 public immutable initialValue;
    uint256 public number;
    address public immutable deployer;
    uint256 public immutable deploymentBlock;
    uint256 public immutable deploymentTime;
    event Deployed(address indexed deployer, uint256 value);

    constructor(uint256 _initialValue) {
        require(_initialValue > 0, "Initial value must be > 0");
        initialValue = _initialValue;
        number = _initialValue;
        deployer = msg.sender;
        deploymentBlock = block.number;
        deploymentTime = block.timestamp;

        emit Deployed(msg.sender, _initialValue);
    }

    function update(uint256 _value) public {
        require(_value != number, "Same value");
        number = _value;
    }
    function getValues()
        public
        view
        returns (uint256 initial, uint256 current)
    {
        return (initialValue, number);
    }
}
