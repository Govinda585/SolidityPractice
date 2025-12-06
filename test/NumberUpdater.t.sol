// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;
import "forge-std/Test.sol";
import {NumberUpdater} from "../src/NumberUpdater.sol";
contract NumberUpdaterTest is Test {
    NumberUpdater public numberUpdater;
    event AmountUpdated(
        address indexed by,
        uint256 oldAmount,
        uint256 newAmount
    );
    function setUp() public {
        numberUpdater = new NumberUpdater();
    }

    function testRevertAmountEqualOrLessThanZero() public {
        vm.expectRevert();
        numberUpdater.updateAmount(0);
    }

    function testRevertOldAmountIsSameAsNewAmount() public {
        numberUpdater.updateAmount(10);
        vm.expectRevert();
        numberUpdater.updateAmount(10);
    }

    function testUpdateAmount() public {
        numberUpdater.updateAmount(12);
        assertEq(numberUpdater.amount(), 12);
    }

    function testEmitUpdatedAmount() public {
        numberUpdater.updateAmount(10);

        vm.expectEmit(true, false, false, true);
        emit AmountUpdated(address(this), 10, 15);
        numberUpdater.updateAmount(15);
    }

    function testRestAmount() public {
        numberUpdater.updateAmount(10);
        numberUpdater.reset();
        assertEq(numberUpdater.amount(), 0);
    }

    function testEmitEventAmountUpdated() public {
        numberUpdater.updateAmount(5);
        vm.expectEmit(true, false, false, true);
        emit AmountUpdated(address(this), 5, 0);
        numberUpdater.reset();
    }

    function testFuzz(uint256 amount) public {
        vm.assume(amount > 0);
        numberUpdater.updateAmount(amount);
        assertEq(numberUpdater.amount(), amount);
    }
}
