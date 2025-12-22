// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {EtherVault} from "../src/EtherVault.sol";

contract EtherVaultTest is Test {
    EtherVault public etherVault;
    address user;

    // Events must match the contract signature
    event Deposited(
        address indexed by,
        uint256 amount,
        uint256 newUserBalance,
        uint256 newTotalBalance
    );

    event Withdrawn(
        address indexed by,
        uint256 amount,
        uint256 remainingUserBalance
    );

    /*//////////////////////////////////////////////////////////////
                                SETUP
    //////////////////////////////////////////////////////////////*/
    function setUp() public {
        etherVault = new EtherVault();
        user = makeAddr("user");
    }

    /*//////////////////////////////////////////////////////////////
                              DEPOSIT TESTS
    //////////////////////////////////////////////////////////////*/

    function testRevertOnDepositZeroEth() public {
        vm.expectRevert("Must send Ether");
        etherVault.deposit();
    }

    function testDepositUpdatesBalances() public {
        vm.deal(user, 5 ether);
        vm.prank(user);
        etherVault.deposit{value: 4 ether}();

        assertEq(
            etherVault.balanceOf(user),
            4 ether,
            "User balance incorrect after deposit"
        );
        assertEq(
            etherVault.totalBalance(),
            4 ether,
            "Vault total balance incorrect after deposit"
        );
        assertEq(
            address(etherVault).balance,
            4 ether,
            "Contract balance incorrect after deposit"
        );
    }

    function testEmitEventOnDeposit() public {
        vm.deal(user, 50 ether);

        // First deposit to setup state
        vm.prank(user);
        etherVault.deposit{value: 10 ether}();

        // Expect event for second deposit
        vm.expectEmit(true, false, false, true);
        emit Deposited(user, 10 ether, 20 ether, 20 ether);

        vm.prank(user);
        etherVault.deposit{value: 10 ether}();
    }

    /*//////////////////////////////////////////////////////////////
                             WITHDRAW TESTS
    //////////////////////////////////////////////////////////////*/

    function testRevertOnWithdrawWithNoBalance() public {
        vm.deal(user, 0);
        vm.prank(user);
        vm.expectRevert("No balance to withdraw");
        etherVault.withdraw();
    }

    function testWithdrawFullBalanceTransfersEth() public {
        vm.deal(user, 50 ether);

        vm.prank(user);
        etherVault.deposit{value: 10 ether}();

        uint256 userBalanceBefore = user.balance;
        uint256 vaultBalanceBefore = address(etherVault).balance;

        vm.expectEmit(true, false, false, true);
        emit Withdrawn(user, 10 ether, 0);

        vm.prank(user);
        etherVault.withdraw();

        assertEq(
            user.balance,
            userBalanceBefore + 10 ether,
            "ETH not transferred to user"
        );
        assertEq(
            address(etherVault).balance,
            vaultBalanceBefore - 10 ether,
            "Vault balance incorrect after withdraw"
        );
        assertEq(
            etherVault.balanceOf(user),
            0,
            "User balance not zero after withdraw"
        );
    }

    function testWithdrawPartialAmountTransfersEth() public {
        vm.deal(user, 10 ether);

        vm.prank(user);
        etherVault.deposit{value: 5 ether}();

        uint256 userBalanceBefore = user.balance;

        vm.expectEmit(true, false, false, true);
        emit Withdrawn(user, 3 ether, 2 ether);

        vm.prank(user);
        etherVault.withdrawAmount(3 ether);

        assertEq(
            user.balance,
            userBalanceBefore + 3 ether,
            "Partial withdraw did not transfer ETH"
        );
        assertEq(
            etherVault.balanceOf(user),
            2 ether,
            "User balance incorrect after partial withdraw"
        );
        assertEq(
            etherVault.totalBalance(),
            2 ether,
            "Vault total balance incorrect after partial withdraw"
        );
        assertEq(
            address(etherVault).balance,
            2 ether,
            "Contract balance incorrect after partial withdraw"
        );
    }

    function testRevertOnWithdrawAmountZero() public {
        vm.prank(user);
        vm.expectRevert("Amount must be > 0");
        etherVault.withdrawAmount(0);
    }

    function testRevertOnWithdrawAmountExceedBalance() public {
        vm.deal(user, 10 ether);

        vm.prank(user);
        etherVault.deposit{value: 4 ether}();

        vm.prank(user);
        vm.expectRevert("Insufficent Balance");
        etherVault.withdrawAmount(5 ether);
    }

    /*//////////////////////////////////////////////////////////////
                          RECEIVE & FALLBACK TESTS
    //////////////////////////////////////////////////////////////*/

    function testReceiveFunctionDirectEth() public {
        vm.deal(user, 10 ether);

        vm.prank(user);
        (bool success, ) = payable(address(etherVault)).call{value: 3 ether}(
            ""
        );
        require(success, "Direct ETH send failed");

        assertEq(
            address(etherVault).balance,
            3 ether,
            "Contract balance incorrect after receive"
        );
    }

    function testFallbackFunctionCallsDeposit() public {
        vm.deal(user, 10 ether);

        vm.expectEmit(true, false, false, true);
        emit Deposited(user, 2 ether, 2 ether, 2 ether);

        vm.prank(user);
        (bool success, ) = address(etherVault).call{value: 2 ether}(
            abi.encodeWithSignature("nonExistingFunction()")
        );
        require(success, "Fallback call failed");

        assertEq(
            etherVault.balanceOf(user),
            2 ether,
            "User balance incorrect after fallback deposit"
        );
        assertEq(
            etherVault.totalBalance(),
            2 ether,
            "Total balance incorrect after fallback deposit"
        );
        assertEq(
            address(etherVault).balance,
            2 ether,
            "Contract balance mismatch after fallback deposit"
        );
    }

    /*//////////////////////////////////////////////////////////////
                          CONTRACT BALANCE TEST
    //////////////////////////////////////////////////////////////*/

    function testGetContractBalance() public {
        vm.deal(user, 10 ether);

        vm.prank(user);
        etherVault.deposit{value: 5 ether}();

        assertEq(
            etherVault.getContractBalance(),
            5 ether,
            "getContractBalance incorrect"
        );
        assertEq(
            address(etherVault).balance,
            5 ether,
            "Contract balance mismatch"
        );
    }
}
