// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, stdError} from "forge-std/Test.sol";
import {BasicModifier} from "../src/BasicModifier.sol";

contract BasicModifierTest is Test {
    BasicModifier internal basicModifier;

    address internal owner;
    address internal attacker;
    address internal newOwner;

    /*//////////////////////////////////////////////////////////////
                                SETUP
    //////////////////////////////////////////////////////////////*/

    function setUp() public {
        owner = makeAddr("owner");
        attacker = makeAddr("attacker");
        newOwner = makeAddr("newOwner");

        vm.prank(owner);
        basicModifier = new BasicModifier();
    }

    /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    function test_Constructor_SetsOwnerAndEmitsEvent() public {
        vm.expectEmit(true, true, false, false);
        emit BasicModifier.OwnershipTransferred(address(0), owner);

        vm.prank(owner);
        BasicModifier contractInstance = new BasicModifier();

        assertEq(contractInstance.owner(), owner);
    }

    /*//////////////////////////////////////////////////////////////
                        ONLY OWNER MODIFIER
    //////////////////////////////////////////////////////////////*/

    function test_Revert_WhenNonOwnerCallsOnlyOwnerFunction() public {
        vm.prank(attacker);
        vm.expectRevert(
            abi.encodeWithSelector(
                BasicModifier.OnlyOwnerAllowed.selector,
                attacker
            )
        );

        basicModifier.setSecretValue(1);
    }

    function test_OwnerCanCallOnlyOwnerFunction() public {
        vm.prank(owner);
        basicModifier.setSecretValue(42);

        assertEq(basicModifier.secretValue(), 42);
    }

    /*//////////////////////////////////////////////////////////////
                        TRANSFER OWNERSHIP
    //////////////////////////////////////////////////////////////*/

    function test_TransferOwnership_UpdatesOwnerAndEmitsEvent() public {
        vm.prank(owner);
        vm.expectEmit(true, true, false, false);
        emit BasicModifier.OwnershipTransferred(owner, newOwner);

        basicModifier.transferOwnership(newOwner);

        assertEq(basicModifier.owner(), newOwner);
    }

    function test_Revert_TransferOwnership_ZeroAddress() public {
        vm.prank(owner);
        vm.expectRevert(BasicModifier.InvalidAddress.selector);

        basicModifier.transferOwnership(address(0));
    }

    function test_Revert_NonOwnerCannotTransferOwnership() public {
        vm.prank(attacker);
        vm.expectRevert(
            abi.encodeWithSelector(
                BasicModifier.OnlyOwnerAllowed.selector,
                attacker
            )
        );

        basicModifier.transferOwnership(newOwner);
    }

    /*//////////////////////////////////////////////////////////////
                        WITHDRAW ALL ETH
    //////////////////////////////////////////////////////////////*/

    function test_Revert_Withdraw_WhenNoETH() public {
        vm.prank(owner);
        vm.expectRevert("No ETH to withdraw");

        basicModifier.withdrawAll();
    }

    function test_WithdrawAll_SendsETHToOwner() public {
        uint256 depositAmount = 5 ether;

        vm.deal(attacker, depositAmount);
        vm.prank(attacker);
        (bool sent, ) = address(basicModifier).call{value: depositAmount}("");
        assertTrue(sent);

        uint256 ownerBalanceBefore = owner.balance;

        vm.prank(owner);
        basicModifier.withdrawAll();

        assertEq(address(basicModifier).balance, 0);
        assertEq(owner.balance, ownerBalanceBefore + depositAmount);
    }

    function test_Revert_NonOwnerCannotWithdraw() public {
        vm.prank(attacker);
        vm.expectRevert(
            abi.encodeWithSelector(
                BasicModifier.OnlyOwnerAllowed.selector,
                attacker
            )
        );

        basicModifier.withdrawAll();
    }

    /*//////////////////////////////////////////////////////////////
                        RECEIVE FUNCTION
    //////////////////////////////////////////////////////////////*/

    function test_ContractCanReceiveETH() public {
        uint256 amount = 1 ether;

        vm.deal(attacker, amount);
        vm.prank(attacker);
        (bool success, ) = address(basicModifier).call{value: amount}("");
        assertTrue(success);

        assertEq(address(basicModifier).balance, amount);
    }
}
