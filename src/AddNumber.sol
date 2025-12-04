// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract AddNumber {
    event Added(address indexed caller, uint256 a, uint256 b, uint256 result);

    function add(uint256 a, uint256 b) public returns (uint256) {
        uint256 result = a + b;
        emit Added(msg.sender, a, b, result);
        return result;
    }

    function addMany(uint256[] calldata numbers) public pure returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < numbers.length; i++) {
            total += numbers[i];
        }
        return total;
    }
}
