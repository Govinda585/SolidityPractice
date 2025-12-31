// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {FallBackLogger} from "../src/FallBackLogger.sol";

contract FallBackLoggerTest is Test {
    FallBackLogger public fallBackLogger;

    address USER = makeAddr("user");
    event EthReceived(address indexed by, uint256 amount);

    function setUp() public {
        fallBackLogger = new FallBackLogger();
        vm.deal(USER, 5 ether);
    }

    function testReceive() public {
        vm.prank(USER);
        vm.expectEmit(true, false, false, true);
        emit EthReceived(USER, 1 ether);
        (bool success, ) = address(fallBackLogger).call{value: 1 ether}("");
        assertTrue(success);
    }

    function testFallback() public {
        vm.prank(USER);
        vm.expectEmit(true, false, false, true);
        emit EthReceived(USER, 2 ether);
        (bool success, ) = address(fallBackLogger).call{value: 2 ether}(
            hex"dead"
        );
        assertTrue(success);
    }
}
