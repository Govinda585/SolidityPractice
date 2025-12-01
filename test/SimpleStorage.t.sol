// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage simpleStorage;
    function setUp() public {
        simpleStorage = new SimpleStorage();
    }

    function testSetValue() public {
        simpleStorage.store(10);
        assertEq(simpleStorage.myNumber(), 10);
    }

    function testGetValue() public {
        simpleStorage.store(50);
        uint256 result = simpleStorage.retrieve();
        assertEq(result, 50);
    }
}
