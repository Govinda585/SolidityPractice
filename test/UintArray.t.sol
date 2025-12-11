// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {UintArray} from "../src/UintArray.sol";
import "forge-std/Test.sol";

contract UintArrayTest is Test {
    UintArray uintArray;
    event NumberPushed(
        address indexed by,
        uint256 value,
        uint256 index,
        uint256 newLength
    );
    event NumberPopped(
        address indexed by,
        uint256 poppedValue,
        uint256 newLength
    );
    function setUp() public {
        uintArray = new UintArray();
    }
    function testPushArrayValueAndLength() public {
        uintArray.push(5);
        // assert length
        assertEq(uintArray.count(), 1);
        // assert value
        assertEq(uintArray.getByIndex(0), 5);
    }

    function testPushEmitEventNumberPushed() public {
        // assert old length is zeo
        assertEq(uintArray.count(), 0);
        vm.expectEmit(true, false, false, true);
        emit NumberPushed(address(this), 4, 0, 1);
        uintArray.push(4);
    }

    function testPushManyValues() public {
        uint256[] memory _values = new uint256[](3);
        _values[0] = 1;
        _values[1] = 2;
        _values[2] = 3;
        uintArray.pushMany(_values);
        // assert length
        assertEq(uintArray.count(), 3);

        // assert values
        assertEq(uintArray.getByIndex(0), 1);
        assertEq(uintArray.getByIndex(1), 2);
        assertEq(uintArray.getByIndex(2), 3);
    }
    function testGetByIndexEmitEvent() public {
        uintArray.push(23);
        uintArray.push(25);
        vm.expectRevert("Index out of bounds");
        uintArray.getByIndex(2);
    }
    function testGetValueByIndex() public {
        uintArray.push(21);
        uintArray.push(24);
        assertEq(uintArray.getByIndex(1), 24);
    }

    function testGetAll() public {
        uintArray.push(21);
        uintArray.push(24);

        uint256[] memory all = uintArray.getAll();

        assertEq(all.length, 2);
        assertEq(all[0], 21);
        assertEq(all[1], 24);
    }

    function testCount() public {
        uintArray.push(55);
        uintArray.push(56);

        assertEq(uintArray.count(), 2);
    }

    function testLastElement() public {
        uintArray.push(4);
        uintArray.push(32);
        assertEq(uintArray.getlastElement(), 32);
    }

    function testRevertPop() public {
        vm.expectRevert("Cannot pop empty array");
        uintArray.pop();
    }

    function testPopValue() public {
        uintArray.push(44);
        uintArray.push(22);
        uintArray.pop();
        assertEq(uintArray.getlastElement(), 44);
    }
    function testPopEmitEventNumberPopped() public {
        uintArray.push(33);
        uintArray.push(21);
        vm.expectEmit(true, false, false, true);
        emit NumberPopped(address(this), 21, 1);
        uintArray.pop();
    }
}
