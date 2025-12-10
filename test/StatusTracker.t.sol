// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {StatusTracker} from "../src/StatusTracker.sol";
import "forge-std/Test.sol";
contract StatusTrackerTest is Test {
    StatusTracker statusTracker;
    uint256 deploymentTime;

    event StatusChanged(
        address indexed by,
        StatusTracker.Status indexed oldStatus,
        StatusTracker.Status newStatus,
        uint256 timestamp
    );

    function setUp() public {
        uint256 deployTime = vm.getBlockTimestamp();
        statusTracker = new StatusTracker();
        deploymentTime = deployTime;
    }

    function testConstructorValues() public {
        assertEq(statusTracker.owner(), address(this));
        assertEq(uint(statusTracker.status()), 0);
        assertEq(statusTracker.lastUpdated(), deploymentTime);
    }

    function testConstructorEmitEventStatusChange() public {
        vm.expectEmit(true, true, false, true);
        emit StatusChanged(
            address(0),
            StatusTracker.Status.Pending,
            StatusTracker.Status.Pending,
            deploymentTime
        );
        new StatusTracker();
    }

    function testActivateRevertOnNotPending() public {
        statusTracker.deactivate();
        vm.expectRevert("Must be Pending");
        statusTracker.activate();
    }

    function testActivateStatusOnlyOwner() public {
        vm.prank(address(0x12));
        vm.expectRevert("Not owner");
        statusTracker.activate();
    }

    function testActivateSuccess() public {
        assertEq(
            uint(statusTracker.status()),
            uint(StatusTracker.Status.Pending)
        );
        vm.expectEmit(true, true, false, true);
        emit StatusChanged(
            address(this),
            StatusTracker.Status.Pending,
            StatusTracker.Status.Active,
            vm.getBlockTimestamp()
        );
        statusTracker.activate();
        assertEq(
            uint(statusTracker.status()),
            uint(StatusTracker.Status.Active)
        );
    }

    function testDeactiveOnlyOwner() public {
        vm.prank(address(44));
        vm.expectRevert();
        statusTracker.deactivate();
    }

    function testDeactivateSuccess() public {
        assertEq(
            uint(statusTracker.status()),
            uint(StatusTracker.Status.Pending)
        );

        vm.expectEmit(true, true, false, true);
        emit StatusChanged(
            address(this),
            StatusTracker.Status.Pending,
            StatusTracker.Status.Inactive,
            vm.getBlockTimestamp()
        );
        statusTracker.deactivate();
        assertEq(
            uint(statusTracker.status()),
            uint(StatusTracker.Status.Inactive)
        );
    }
}
