// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/BalanceTracker.sol";

contract BalanceTrackerTest is Test {
    // Event definitions for Foundry
    event Deposit(address indexed user, uint amount, uint newBalance);
    event Withdrawal(address indexed user, uint amount, uint newBalance);
    event Transfer(address indexed from, address indexed to, uint amount);

    BalanceTracker public balanceTracker;

    function setUp() public {
        balanceTracker = new BalanceTracker();
    }

    /*//////////////////////////////////////////////////////////////
                            DEPOSIT TESTS
    //////////////////////////////////////////////////////////////*/

    function testRevertDepositZeroAddress() public {
        vm.expectRevert("Zero address");
        balanceTracker.deposit(address(0), 10);
    }

    function testRevertDepositAmountZero() public {
        vm.expectRevert("Amount must be greater than zero");
        balanceTracker.deposit(address(this), 0);
    }

    function testDepositBalanceAndSupply() public {
        uint depositAmount = 10;
        address user = address(0x1);

        // Initial balance and total supply
        assertEq(balanceTracker.balanceOf(user), 0);
        assertEq(balanceTracker.totalSupply(), 0);

        // First deposit
        balanceTracker.deposit(user, depositAmount);
        assertEq(balanceTracker.balanceOf(user), depositAmount);
        assertEq(balanceTracker.totalSupply(), depositAmount);

        // Second deposit
        balanceTracker.deposit(user, depositAmount);
        assertEq(balanceTracker.balanceOf(user), depositAmount * 2);
        assertEq(balanceTracker.totalSupply(), depositAmount * 2);
    }

    function testDepositEmitEvent() public {
        address user = address(0x2);
        uint depositAmount = 15;
        uint oldBalance = balanceTracker.balanceOf(user);
        uint expectedBalance = oldBalance + depositAmount;

        vm.expectEmit(true, false, false, true);
        emit Deposit(user, depositAmount, expectedBalance);

        balanceTracker.deposit(user, depositAmount);
    }

    function testFuzzDeposit(address user, uint256 amount) public {
        vm.assume(user != address(0));
        vm.assume(amount > 0);

        uint oldBalance = balanceTracker.balanceOf(user);
        balanceTracker.deposit(user, amount);
        assertEq(balanceTracker.balanceOf(user), oldBalance + amount);
    }

    /*//////////////////////////////////////////////////////////////
                            WITHDRAW TESTS
    //////////////////////////////////////////////////////////////*/

    function testRevertWithdrawZeroAmount() public {
        vm.expectRevert("Amount must be greater than zero");
        balanceTracker.withdraw(address(this), 0);
    }

    function testRevertWithdrawInsufficientBalance() public {
        address user = address(0x3);
        balanceTracker.deposit(user, 5);
        vm.expectRevert("Insufficient balance");
        balanceTracker.withdraw(user, 10);
    }

    function testWithdrawBalanceAndSupply() public {
        address user = address(0x4);
        balanceTracker.deposit(user, 20);

        balanceTracker.withdraw(user, 5);
        assertEq(balanceTracker.balanceOf(user), 15);
        assertEq(balanceTracker.totalSupply(), 15);
    }

    function testWithdrawalEmitEvent() public {
        address user = address(0x5);
        uint depositAmount = 30;
        uint withdrawAmount = 10;

        balanceTracker.deposit(user, depositAmount);

        uint expectedBalance = depositAmount - withdrawAmount;

        vm.expectEmit(true, false, false, true);
        emit Withdrawal(user, withdrawAmount, expectedBalance);

        balanceTracker.withdraw(user, withdrawAmount);
    }

    function testFuzzWithdraw(address user, uint256 amount) public {
        vm.assume(user != address(0));
        vm.assume(amount > 0);

        // Deposit first to allow full withdrawal
        balanceTracker.deposit(user, amount);
        balanceTracker.withdraw(user, amount);

        assertEq(balanceTracker.balanceOf(user), 0);
    }

    /*//////////////////////////////////////////////////////////////
                            TRANSFER TESTS
    //////////////////////////////////////////////////////////////*/

    function testRevertTransferInvalidAddress() public {
        balanceTracker.deposit(address(this), 50);
        vm.expectRevert("Invalid address");
        balanceTracker.transfer(address(0), 10);
    }

    function testRevertTransferInsufficientBalance() public {
        // Address with 0 balance trying to transfer
        vm.expectRevert("Insufficient balance");
        balanceTracker.transfer(address(0x6), 10);
    }

    function testTransferBalanceAndEmitEvents() public {
        address sender = address(this);
        address recipient = address(0x7);
        uint depositAmount = 50;
        uint transferAmount = 20;

        balanceTracker.deposit(sender, depositAmount);

        vm.expectEmit(true, true, false, true);
        emit Transfer(sender, recipient, transferAmount);

        vm.expectEmit(true, false, false, true);
        emit Withdrawal(sender, transferAmount, depositAmount - transferAmount);

        vm.expectEmit(true, false, false, true);
        emit Deposit(recipient, transferAmount, transferAmount);

        balanceTracker.transfer(recipient, transferAmount);

        // Validate balances
        assertEq(
            balanceTracker.balanceOf(sender),
            depositAmount - transferAmount
        );
        assertEq(balanceTracker.balanceOf(recipient), transferAmount);
    }

    function testFuzzTransfer(address recipient, uint256 amount) public {
        vm.assume(recipient != address(0));
        vm.assume(amount > 0);

        address sender = address(this);
        balanceTracker.deposit(sender, amount);

        balanceTracker.transfer(recipient, amount);
        assertEq(balanceTracker.balanceOf(sender), 0);
        assertEq(balanceTracker.balanceOf(recipient), amount);
    }

    /*//////////////////////////////////////////////////////////////
                            HELPER FUNCTION TEST
    //////////////////////////////////////////////////////////////*/

    function testDepositToMyself() public {
        uint depositAmount = 25;
        balanceTracker.depositToMyself(depositAmount);

        assertEq(balanceTracker.balanceOf(address(this)), depositAmount);
        assertEq(balanceTracker.totalSupply(), depositAmount);
    }
}
