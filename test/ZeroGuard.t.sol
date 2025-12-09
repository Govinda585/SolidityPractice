// SPDX-License-Identifer: MIT
pragma solidity ^0.8.30;
import {Test} from "forge-std/Test.sol";
import {ZeroGuard} from "../src/ZeroGuard.sol";
contract ZeroGuardTest is Test {
    ZeroGuard public zeroGuard;
    event ValueSet(address indexed by, uint256 newValue);

    function setUp() public {
        zeroGuard = new ZeroGuard();
    }

    function testRevertOnValueZero() public {
        vm.expectRevert();
        zeroGuard.setNumber(0);
    }
    function testSetNumber() public {
        zeroGuard.setNumber(5);
        assertEq(zeroGuard.value(), 5);
    }
    function testEventEmitValueSet() public {
        vm.expectEmit(true, false, false, true);
        emit ValueSet(address(this), 55);
        zeroGuard.setNumber(55);
    }

    function testRevertOnValuZeroSecond() public {
        vm.expectRevert();
        zeroGuard.setValueRevert(0);
    }

    function testRevertOnValueZeroModern() public {
        vm.expectRevert(ZeroGuard.ZeroValueNotAllowed.selector);
        zeroGuard.setValueModern(0);
    }

    function testRevertOnValueZeroWithRange() public {
        vm.expectRevert(
            abi.encodeWithSelector(ZeroGuard.InvalidInput.selector, 10000000)
        );
        zeroGuard.setValueWithRange(10000000);
    }
}
