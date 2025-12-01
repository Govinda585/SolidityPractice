// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {SimpleStorageName} from "../src/SimpleStorageName.sol";

contract SimpleStorageNameTest is Test {
    SimpleStorageName simpleStorageName;

    event NameChanged(address indexed by, string oldName, string newName);

    function setUp() public {
        simpleStorageName = new SimpleStorageName();
    }

    function testSet() public {
        simpleStorageName.set("govinda");
        assertEq(simpleStorageName.get(), "govinda");
    }

    function testGet() public {
        simpleStorageName.set("ramesh");
        string memory name = simpleStorageName.get();
        assertEq(name, "ramesh");
    }

    function testNameChangedEmitsEvent() public {
        // Set initial name
        simpleStorageName.set("govinda");

        // Expect next event
        vm.expectEmit(true, false, false, true);
        emit NameChanged(address(this), "govinda", "ramesh");

        simpleStorageName.set("ramesh");
    }

    // no access control
    function testAnyoneCanSet() public {
        address randomUser = address(1);
        // vm is Foundry’s cheatcode interface.
        // Cheatcodes = special functions provided by Foundry
        // that let you control the EVM while testing (
        // like time travel, chaning msg.sender, expecting events etc).
        vm.prank(randomUser);
        simpleStorageName.set("James");
        assertEq(simpleStorageName.get(), "James");
    }

    function testUpdateNameMultipleTimes() public {
        simpleStorageName.set("A");
        assertEq(simpleStorageName.get(), "A");

        simpleStorageName.set("B");
        assertEq(simpleStorageName.get(), "B");

        simpleStorageName.set("C");
        assertEq(simpleStorageName.get(), "C");
    }

    function testSetEmptyString() public {
        simpleStorageName.set("");
        assertEq(simpleStorageName.get(), "");
    }

    // Fuzz Testing
    // test with random value

    function testFuzzSet(string memory randomName) public {
        simpleStorageName.set(randomName);
        assertEq(simpleStorageName.get(), randomName);
    }
}
