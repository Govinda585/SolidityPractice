// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {BooleanToggle} from "../src/BooleanToggle.sol";

// name in this format: test[Function/Feature]_[Condition]_[ExpectedOutcome]
contract BooleanToggleTest is Test {
    BooleanToggle booleanToggle;
    event FlagToggled(address indexed by, bool indexed newState);

    function setUp() public {
        booleanToggle = new BooleanToggle();
    }

    // State tests
    function testDefaultState_IsFalse() public view {
        assertEq(booleanToggle.isActive(), false);
    }

    function testToggle_FlipsStateCorrectly() public {
        assertEq(booleanToggle.isActive(), false);

        booleanToggle.toggle();
        assertEq(booleanToggle.isActive(), true);

        booleanToggle.toggle();
        assertEq(booleanToggle.isActive(), false);
    }

    function testTurnOn_SetsStateToTrueAndEmitsEvent() public {
        vm.expectEmit(true, true, false, false);
        emit FlagToggled(address(this), true);

        booleanToggle.turnOn();
        assertEq(booleanToggle.isActive(), true);
    }

    function testTurnOff_SetsStateToFalseAndEmitsEvent() public {
        booleanToggle.turnOn();
        assertEq(booleanToggle.isActive(), true);

        vm.expectEmit(true, true, false, false);
        emit FlagToggled(address(this), false);

        booleanToggle.turnOff();
        assertEq(booleanToggle.isActive(), false);
    }

    function testToggle_EmitsEvent() public {
        vm.expectEmit(true, true, false, false);
        emit FlagToggled(address(this), true);

        booleanToggle.toggle();
    }

    function testGetStatus_ReturnsCurrentState() public {
        booleanToggle.turnOn();
        assertEq(booleanToggle.getStatus(), true);
    }

    function testMultipleToggles_MaintainsCorrectParity() public {
        assertEq(booleanToggle.isActive(), false);

        for (uint i = 0; i < 10; i++) {
            booleanToggle.toggle();
        }

        // 10 toggles → even → should end as false
        assertEq(booleanToggle.isActive(), false);
    }

    // Negative / edge case tests
    function testTurnOn_WhenAlreadyActive_DoesNotEmitEvent() public {
        booleanToggle.turnOn();
        assertEq(booleanToggle.isActive(), true);

        // Calling again should do nothing
        booleanToggle.turnOn();
        assertEq(booleanToggle.isActive(), true);
    }

    function testTurnOff_WhenAlreadyInactive_DoesNotEmitEvent() public {
        assertEq(booleanToggle.isActive(), false);

        // Calling when inactive should do nothing
        booleanToggle.turnOff();
        assertEq(booleanToggle.isActive(), false);
    }
}
