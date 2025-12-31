// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {StructExample} from "../src/StructExample.sol";

contract StructExampleTest is Test {
    StructExample public structExample;
    function setUp() public {
        structExample = new StructExample();
    }

    function testSetStruct() public {
        structExample.setPerson("Govinda", 22);
        (string memory name, uint256 age) = structExample.person();
        assertEq(name, "Govinda");
        assertEq(age, 22);
    }

    function testGetStruct() public {
        structExample.setPerson("Govinda", 22);
        (string memory name, uint256 age) = structExample.getPerson();
        assertEq(name, "Govinda");
        assertEq(age, 22);
    }
}
