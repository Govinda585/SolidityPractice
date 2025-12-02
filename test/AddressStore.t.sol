// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {AddressStore} from "../src/AddressStore.sol";

contract AddressStoreTest is Test {
    AddressStore addressStore;

    event AddressUpdated(
        address indexed by,
        address indexed oldAddress,
        address indexed newAddress
    );

    function setUp() public {
        addressStore = new AddressStore();
    }
    function testRevert() public {
        vm.expectRevert(bytes("Zero address not allowed"));
        addressStore.setAddress(address(0));
    }

    function testAddressUpdatedEmitEvent() public {
        vm.expectEmit(true, true, true, false);
        emit AddressUpdated(address(this), address(0), address(2));
        addressStore.setAddress(address(2));
    }

    function testSetAddress() public {
        addressStore.setAddress(address(2));
        assertEq(addressStore.storedAddress(), address(2));
    }

    function testGetAddress() public {
        addressStore.setAddress(address(0x212));
        assertEq(addressStore.getAddress(), address(0x212));
    }

    function testIsContractReturnFalseForEOA() public {
        addressStore.setAddress(address(0x55));
        bool result = addressStore.isContract();
        assertFalse(result);
    }
    function testIsContractReturnTrueForContract() public {
        addressStore = new AddressStore();
        addressStore.setAddress(address(addressStore));
        bool result = addressStore.isContract();
        assertTrue(result);
    }

    function testFuzzSetNonZeroAddress(address randomAddress) public {
        vm.assume(randomAddress != address(0));
        console.log("Fuzzed address:", uint256(uint160(randomAddress)));
        addressStore.setAddress(randomAddress);
        assertEq(addressStore.getAddress(), randomAddress);
    }
}
