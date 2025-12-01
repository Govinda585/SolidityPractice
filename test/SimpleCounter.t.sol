// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {SimpleCounter} from "../src/SimpleCounter.sol";

contract SimpleCounterTest is Test {
    SimpleCounter simpleCounter;

    // Events to match the contract
    event Increased(address indexed by, uint256 amount, uint256 newValue);
    event Decreased(address indexed by, uint256 amount, uint256 newValue);

    // -------------------------
    // Setup
    // -------------------------
    function setUp() public {
        simpleCounter = new SimpleCounter();
    }

    // -------------------------
    // INCREASE BY 1
    // -------------------------
    function testIncreaseByOne_StateChange() public {
        // Act
        simpleCounter.increase();

        // Assert
        assertEq(simpleCounter.number(), 1);
    }

    function testIncreaseByOne_EmitEvent() public {
        // Arrange
        vm.expectEmit(true, false, false, true);

        // Act + Assert
        emit Increased(address(this), 1, 1);
        simpleCounter.increase();
    }

    // -------------------------
    // DECREASE BY 1
    // -------------------------
    function testDecreaseByOne_StateChange() public {
        // Arrange
        simpleCounter.increase();

        // Act
        simpleCounter.decrease();

        // Assert
        assertEq(simpleCounter.number(), 0);
    }

    function testDecreaseByOne_EmitEvent() public {
        // Arrange
        simpleCounter.increase();
        vm.expectEmit(true, false, false, true);

        // Act + Assert
        emit Decreased(address(this), 1, 0);
        simpleCounter.decrease();
    }

    function testDecreaseByOne_Revert_WhenZero() public {
        // Act + Assert
        vm.expectRevert("Cannot go negative");
        simpleCounter.decrease();
    }

    // -------------------------
    // INCREASE BY AMOUNT
    // -------------------------
    function testIncreaseBy_Revert_WhenZero() public {
        vm.expectRevert("Amount must be > 0");
        simpleCounter.increaseBy(0);
    }

    function testIncreaseBy_UserInput_StateChange() public {
        // Arrange
        uint256 amount = 10;

        // Act
        simpleCounter.increaseBy(amount);

        // Assert
        assertEq(simpleCounter.number(), 10);
    }

    function testIncreaseBy_UserInput_EmitEvent() public {
        vm.expectEmit(true, false, false, true);
        emit Increased(address(this), 5, 5);
        simpleCounter.increaseBy(5);
    }

    function testIncreaseBy_Fuzz(uint256 amount) public {
        vm.assume(amount > 0); // ignore zero
        simpleCounter.increaseBy(amount);
        assertEq(simpleCounter.number(), amount);
    }

    // -------------------------
    // DECREASE BY AMOUNT
    // -------------------------
    function testDecreaseBy_Revert_WhenZero() public {
        vm.expectRevert("Amount must be > 0");
        simpleCounter.decreaseBy(0);
    }

    function testDecreaseBy_Revert_WhenTooBig() public {
        vm.expectRevert("Cannot go negative");
        simpleCounter.decreaseBy(1); // number = 0 initially
    }

    function testDecreaseBy_UserInput_StateChange() public {
        simpleCounter.increaseBy(20);
        simpleCounter.decreaseBy(5);
        assertEq(simpleCounter.number(), 15);
    }

    function testDecreaseBy_UserInput_EmitEvent() public {
        simpleCounter.increaseBy(10);
        vm.expectEmit(true, false, false, true);
        emit Decreased(address(this), 5, 5);
        simpleCounter.decreaseBy(5);
    }

    function testDecreaseBy_Fuzz(
        uint256 initial,
        uint256 decreaseAmount
    ) public {
        vm.assume(initial >= decreaseAmount && decreaseAmount > 0);

        simpleCounter.increaseBy(initial);
        simpleCounter.decreaseBy(decreaseAmount);

        assertEq(simpleCounter.number(), initial - decreaseAmount);
    }

    // -------------------------
    // MULTIPLE OPERATIONS / SEQUENCE
    // -------------------------
    function testMultipleOperations_StateAccumulation() public {
        simpleCounter.increaseBy(10);
        simpleCounter.decreaseBy(3);
        simpleCounter.increaseBy(7);
        simpleCounter.decreaseBy(4);
        assertEq(simpleCounter.number(), 10);
    }

    // -------------------------
    // INVARIANT TESTS
    // -------------------------

    function testInvariant_NumberNeverNegative(
        uint256 increaseAmount,
        uint256 decreaseAmount
    ) public {
        vm.assume(increaseAmount > 0); // skip zero
        vm.assume(decreaseAmount > 0); // skip zero
        vm.assume(decreaseAmount <= increaseAmount);

        simpleCounter.increaseBy(increaseAmount);
        simpleCounter.decreaseBy(decreaseAmount);

        assert(simpleCounter.number() >= 0);
    }
}
