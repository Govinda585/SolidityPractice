// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {EtherSender} from "../src/EtherSender.sol";

contract RevertingReceiver {
    receive() external payable {
        revert("I reject ETH");
    }
}

contract EtherSenderTest is Test {
    EtherSender etherSender;

    address owner = makeAddr("owner");
    address user = makeAddr("user");

    function setUp() public {
        vm.prank(owner);
        etherSender = new EtherSender();
    }

    /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    function testOwnerSetCorrectly() public {
        assertEq(etherSender.owner(), owner, "Owner not set correctly");
    }

    /*//////////////////////////////////////////////////////////////
                        ACCESS CONTROL
    //////////////////////////////////////////////////////////////*/

    function testSendEtherRevertsIfNotOwner() public {
        vm.deal(address(etherSender), 1 ether);

        vm.prank(user);
        vm.expectRevert("No permission");
        etherSender.sendEther(payable(user), 1 ether);
    }

    function testWithdrawAllRevertsIfNotOwner() public {
        vm.deal(address(etherSender), 1 ether);

        vm.prank(user);
        vm.expectRevert("No permission");
        etherSender.withdrawAll(payable(user));
    }

    /*//////////////////////////////////////////////////////////////
                        INPUT VALIDATION
    //////////////////////////////////////////////////////////////*/

    function testSendEtherRevertsOnZeroAddress() public {
        vm.deal(address(etherSender), 1 ether);

        vm.prank(owner);
        vm.expectRevert("Zero address not allowed");
        etherSender.sendEther(payable(address(0)), 1 ether);
    }

    function testSendEtherRevertsOnZeroAmount() public {
        vm.deal(address(etherSender), 1 ether);

        vm.prank(owner);
        vm.expectRevert("Amount must be > 0");
        etherSender.sendEther(payable(user), 0);
    }

    function testSendEtherRevertsOnInsufficientBalance() public {
        vm.prank(owner);
        vm.expectRevert("Insufficient contract balance");
        etherSender.sendEther(payable(user), 1 ether);
    }

    /*//////////////////////////////////////////////////////////////
                        SEND ETHER
    //////////////////////////////////////////////////////////////*/

    function testSendEtherToEOA() public {
        vm.deal(address(etherSender), 5 ether);

        uint256 sendAmount = 1 ether;
        uint256 userBalanceBefore = user.balance;
        uint256 contractBalanceBefore = address(etherSender).balance;

        vm.prank(owner);
        etherSender.sendEther(payable(user), sendAmount);

        assertEq(
            user.balance,
            userBalanceBefore + sendAmount,
            "User balance incorrect"
        );
        assertEq(
            address(etherSender).balance,
            contractBalanceBefore - sendAmount,
            "Contract balance incorrect"
        );
    }

    function testSendEtherRevertsIfReceiverRejectsETH() public {
        vm.deal(address(etherSender), 1 ether);

        RevertingReceiver receiver = new RevertingReceiver();

        vm.prank(owner);
        vm.expectRevert("ETH transfer failed");
        etherSender.sendEther(payable(address(receiver)), 1 ether);
    }

    /*//////////////////////////////////////////////////////////////
                        WITHDRAW ALL
    //////////////////////////////////////////////////////////////*/

    function testWithdrawAllTransfersFullBalance() public {
        uint256 deposit = 3 ether;
        vm.deal(address(etherSender), deposit);
        uint256 userBalanceBefore = user.balance;

        vm.prank(owner);
        etherSender.withdrawAll(payable(user));

        assertEq(
            address(etherSender).balance,
            0,
            "Contract balance should be zero"
        );
        assertEq(
            user.balance,
            userBalanceBefore + deposit,
            "User balance incorrect after withdrawAll"
        );
    }

    function testWithdrawAllRevertsWhenNoEther() public {
        vm.prank(owner);
        vm.expectRevert("No Ether to withdraw");
        etherSender.withdrawAll(payable(user));
    }

    /*//////////////////////////////////////////////////////////////
                        BALANCE VIEW
    //////////////////////////////////////////////////////////////*/

    function testGetBalanceReturnsCorrectValue() public {
        vm.deal(address(etherSender), 5 ether);
        assertEq(
            etherSender.getBalance(),
            5 ether,
            "getBalance returned incorrect value"
        );
    }

    function testDirectContractBalanceRead() public {
        vm.deal(address(etherSender), 2 ether);
        assertEq(
            address(etherSender).balance,
            2 ether,
            "Contract balance mismatch"
        );
    }
}
