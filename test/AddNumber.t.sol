// test/AddNumberTest.t.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {AddNumber} from "../src/AddNumber.sol";

contract AddNumberTest is Test {
    AddNumber public addNumber;
    address public alice = address(0xA1);
    address public bob = address(0xB0);

    // Event from the contract
    event Added(address indexed caller, uint256 a, uint256 b, uint256 result);

    // ──────────────────────────────────────────────────
    // Beautiful toArray() helpers — production standard
    // ──────────────────────────────────────────────────
    function toArray() internal pure returns (uint256[] memory r) {
        r = new uint256[](0);
    }

    function toArray(uint256 a) internal pure returns (uint256[] memory r) {
        r = new uint256[](1);
        r[0] = a;
    }

    function toArray(
        uint256 a,
        uint256 b
    ) internal pure returns (uint256[] memory r) {
        r = new uint256[](2);
        r[0] = a;
        r[1] = b;
    }

    function toArray(
        uint256 a,
        uint256 b,
        uint256 c
    ) internal pure returns (uint256[] memory r) {
        r = new uint256[](3);
        r[0] = a;
        r[1] = b;
        r[2] = c;
    }

    function toArray(
        uint256 a,
        uint256 b,
        uint256 c,
        uint256 d
    ) internal pure returns (uint256[] memory r) {
        r = new uint256[](4);
        r[0] = a;
        r[1] = b;
        r[2] = c;
        r[3] = d;
    }

    function toArray(
        uint256 a,
        uint256 b,
        uint256 c,
        uint256 d,
        uint256 e
    ) internal pure returns (uint256[] memory r) {
        r = new uint256[](5);
        r[0] = a;
        r[1] = b;
        r[2] = c;
        r[3] = d;
        r[4] = e;
    }

    // ──────────────────────────────────────────────────
    function setUp() public {
        addNumber = new AddNumber();
    }

    // ──────────────────────────────────────────────────
    // Unit Tests: add()
    // ──────────────────────────────────────────────────
    function test_AddBasic() public {
        assertEq(addNumber.add(5, 10), 15);
        assertEq(addNumber.add(0, 0), 0);
        assertEq(addNumber.add(1, 0), 1);
    }

    function test_AddLargeNumbers() public {
        uint256 a = 2 ** 200;
        uint256 b = 2 ** 200;
        assertEq(addNumber.add(a, b), a + b);
    }

    function test_AddEmitsEvent() public {
        vm.expectEmit(true, false, false, true);
        emit Added(address(this), 7, 8, 15);

        addNumber.add(7, 8);
    }

    function test_AddEmitsEventFromDifferentCaller() public {
        vm.prank(alice);
        vm.expectEmit(true, false, false, true);
        emit Added(alice, 100, 200, 300);

        addNumber.add(100, 200);
    }

    // ──────────────────────────────────────────────────
    // Unit Tests: addMany()
    // ──────────────────────────────────────────────────
    function test_AddManyEmptyArray() public {
        assertEq(addNumber.addMany(toArray()), 0);
    }

    function test_AddManySingleElement() public {
        assertEq(addNumber.addMany(toArray(42)), 42);
    }

    function test_AddManyMultipleElements() public {
        assertEq(addNumber.addMany(toArray(1, 2, 3, 4, 5)), 15);
        assertEq(addNumber.addMany(toArray(10, 20, 30)), 60);
    }

    function test_AddManyLargeArray() public {
        uint256[] memory arr = new uint256[](100);
        for (uint256 i = 0; i < 100; i++) {
            arr[i] = i + 1;
        }
        uint256 expected = 5050; // sum 1..100
        assertEq(addNumber.addMany(arr), expected);
    }

    // ──────────────────────────────────────────────────
    // Fuzz Tests (Foundry automatically runs 1000s of cases)
    // ──────────────────────────────────────────────────
    function testFuzz_Add(uint256 a, uint256 b) public {
        // Bound to prevent overflow in reference calculation
        vm.assume(a <= type(uint256).max - b);
        assertEq(addNumber.add(a, b), a + b);
    }

    function testFuzz_AddMany(uint256[] calldata numbers) public {
        // Limit array length and values to avoid gas/time issues
        vm.assume(numbers.length <= 1000);

        uint256 expected = 0;
        bool overflow = false;

        for (uint256 i = 0; i < numbers.length; i++) {
            uint256 num = numbers[i];
            vm.assume(num < 1e30); // reasonable bound

            if (expected > type(uint256).max - num) {
                overflow = true;
                break;
            }
            expected += num;
        }

        if (overflow) return; // skip cases that would overflow

        assertEq(addNumber.addMany(numbers), expected);
    }

    // ──────────────────────────────────────────────────
    // Invariant / Property-based style (optional but pro)
    // ──────────────────────────────────────────────────
    function test_AddManyIsCommutative(uint256 x, uint256 y) public {
        vm.assume(x <= type(uint256).max - y);
        uint256 sum1 = addNumber.addMany(toArray(x, y));
        uint256 sum2 = addNumber.addMany(toArray(y, x));
        assertEq(sum1, sum2);
    }

    function test_AddManyWithZeroDoesNotChangeSum(uint256 base) public {
        uint256[] memory withZero = toArray(base, 0);
        uint256[] memory without = toArray(base);

        assertEq(addNumber.addMany(withZero), addNumber.addMany(without));
    }
}
