// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {InitializedNumber} from "../src/InitializedNumber.sol";

contract InitializedNumberTest is Test {
    InitializedNumber initializedNumber; // deploy once per test

    event Deployed(address indexed deployer, uint256 value);

    function setUp() public {
        vm.warp(1000); // set timestamp before deployment
        vm.roll(500); // set block number before deployment
        initializedNumber = new InitializedNumber(50);
    }

    function testConstructorInitialValues() public {
        assertEq(initializedNumber.initialValue(), 50);
        assertEq(initializedNumber.number(), 50);
        assertEq(initializedNumber.deployer(), address(this));
        assertEq(initializedNumber.deploymentBlock(), 500);
        assertEq(initializedNumber.deploymentTime(), 1000);
    }

    function testConstructorRevertOnZeroInitialValue() public {
        vm.expectRevert("Initial value must be > 0");
        new InitializedNumber(0);
    }

    function testConstructorEventEmitDeployed() public {
        vm.expectEmit(true, false, false, true);
        emit Deployed(address(this), 43);
        new InitializedNumber(43);
    }

    function testUpdateNumber() public {
        initializedNumber.update(20);
        assertEq(initializedNumber.number(), 20);
    }

    function testUpdateRevertSameValue() public {
        initializedNumber.update(11);
        vm.expectRevert();
        initializedNumber.update(11);
    }

    function testGetValuesInitialAndNumber() public {
        InitializedNumber myNum = new InitializedNumber(28);
        myNum.update(55);

        (uint256 initialValue, uint256 value) = myNum.getValues();

        assertEq(initialValue, 28);
        assertEq(value, 55);
    }

    function testFuzzUpdate(uint256 randomValue) public {
        vm.assume(randomValue != initializedNumber.number());
        initializedNumber.update(randomValue);
        assertEq(initializedNumber.number(), randomValue);
    }
}
