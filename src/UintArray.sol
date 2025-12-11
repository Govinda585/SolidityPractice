// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

contract UintArray {
    uint256[] public numbers;

    event NumberPushed(
        address indexed by,
        uint256 value,
        uint256 index,
        uint256 newLength
    );

    function push(uint256 _value) public {
        uint256 index = numbers.length;
        numbers.push(_value);
        emit NumberPushed(msg.sender, _value, index, numbers.length);
    }

    function pushMany(uint256[] memory _values) public {
        for (uint i = 0; i < _values.length; i++) {
            numbers.push(_values[i]);
        }
    }
    function getByIndex(uint256 index) public view returns (uint256) {
        require(index < numbers.length, "Index out of bounds");
        return numbers[index];
    }

    function getAll() public view returns (uint256[] memory) {
        return numbers;
    }

    function count() public view returns (uint256) {
        return numbers.length;
    }
    function getlastElement() public view returns (uint256) {
        uint lastIndex = numbers.length - 1;
        return numbers[lastIndex];
    }

    event NumberPopped(
        address indexed by,
        uint256 poppedValue,
        uint256 newLength
    );
    function pop() public {
        require(numbers.length > 0, "Cannot pop empty array");
        uint256 popped = numbers[numbers.length - 1];
        numbers.pop();
        emit NumberPopped(msg.sender, popped, numbers.length);
    }
}
