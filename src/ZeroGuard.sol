// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;
// Build a contract with a function that reverts if input is zero.

contract ZeroGuard {
    uint256 public value;
    event ValueSet(address indexed by, uint256 newValue);
    function setNumber(uint256 _value) public {
        require(_value != 0, "Number can not be zero");
        value = _value;
        emit ValueSet(msg.sender, _value);
    }

    function setValueRevert(uint256 _value) public {
        if (_value == 0) {
            revert("Zero not allowed");
        }

        value = _value;
        emit ValueSet(msg.sender, _value);
    }

    // best practice Custom Eror, cheapest gas
    error ZeroValueNotAllowed();
    function setValueModern(uint256 _value) public {
        if (_value == 0) revert ZeroValueNotAllowed();
        value = _value;
        emit ValueSet(msg.sender, _value);
    }

    error InvalidInput(uint256 provided);

    function setValueWithRange(uint256 _value) public {
        if (_value == 0) revert ZeroValueNotAllowed();
        if (_value > 1_000_000) revert InvalidInput(_value);

        value = _value;
        emit ValueSet(msg.sender, _value);
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}
