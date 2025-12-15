//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
import {ArrayLength} from "../src/ArrayLength.sol";
import {Test} from "forge-std/Test.sol";
contract ArrayLengthTest is Test {
    ArrayLength arrayLength;
    event ArrayUpdated(address indexed by, uint256 value, uint256 finalLength);

    function setUp() public {
        arrayLength = new ArrayLength();
    }
    function testRevertOnZeroValueInput() public {
        vm.expectRevert();
        arrayLength.push(0);
    }
    function testPushArrayElement() public {
        arrayLength.push(5);
        arrayLength.push(10);
        // assert length of an array
        assertEq(arrayLength.getLength(), 2);
        // assert element of an array with index value
        assertEq(arrayLength.numbers(0), 5);
        assertEq(arrayLength.numbers(1), 10);
    }

    function testPushEmitEventArrayUpdated() public {
        arrayLength.push(1);
        vm.expectEmit(true, false, false, true);
        emit ArrayUpdated(address(this), 5, 2);
        arrayLength.push(5);
    }

    function testGetLengthOfArray() public {
        arrayLength.push(44);
        arrayLength.push(45);
        arrayLength.push(47);
        arrayLength.push(49);
        assertEq(arrayLength.getLength(), 4);
    }
    function testPopRevertOnArrayLengthZero() public {
        vm.expectRevert();
        arrayLength.pop();
    }

    function testPopArrayElement() public {
        arrayLength.push(12);
        arrayLength.push(44);
        arrayLength.push(12);
        assertEq(arrayLength.pop(), 12);
    }

    function testPopArrayByIndex() public {
        arrayLength.push(12);
        arrayLength.push(44);
        arrayLength.push(12);
        assertEq(arrayLength.popArrayByIndex(1), 44);
    }
}
