// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
// Implement a function to get the length of a dynamic array.

contract ArrayLength {
    uint256[] public numbers;
    error InputError();
    error IndexNotFound();
    error EmptyArray();
    event ArrayUpdated(address indexed by, uint256 value, uint256 finalLength);
    function push(uint256 _value) public {
        if (_value == 0) revert InputError();
        numbers.push(_value);
        emit ArrayUpdated(msg.sender, _value, numbers.length);
    }

    function getLength() public view returns (uint256) {
        return numbers.length;
    }
    function pop() public returns (uint256) {
        if (numbers.length == 0) revert EmptyArray();
        uint256 lastElement = numbers[numbers.length - 1];
        numbers.pop();
        return lastElement;
    }
    function popArrayByIndex(uint256 _index) public returns (uint256) {
        uint256 length = numbers.length;
        if (_index >= length) revert IndexNotFound();
        uint256 value = numbers[_index];
        // move last element into index position
        numbers[_index] = numbers[length - 1];
        // remove element
        numbers.pop();
        return value;
    }
}
