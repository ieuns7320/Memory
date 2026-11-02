// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import "../../src/tokens/MyERC20.sol";

contract MyERC20Test is Test {
    MyERC20 erc20;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address carol = makeAddr("carol");

    function setUp() external {
        erc20 = new MyERC20("MyERC", "M-ERC", 18, 100_000);
        erc20.transfer(alice, 1_000);
        erc20.transfer(bob, 1_000);
        erc20.transfer(carol, 1_000);
    }

    function test_transfer_to_bob() external {
        assertEq(erc20.balanceOf(alice), 1_000);
        assertEq(erc20.balanceOf(bob), 1_000);

        vm.prank(alice);
        erc20.transfer(bob, 50);

        assertEq(erc20.balanceOf(alice), 950);
        assertEq(erc20.balanceOf(bob), 1_050);
    }

    function test_transfer_failed_not_enough_value() external {
        assertEq(erc20.balanceOf(alice), 1_000);

        vm.startPrank(alice);
        vm.expectRevert("Not Enough Value");
        erc20.transfer(bob, 1_001);
        vm.stopPrank();

        vm.assertEq(erc20.balanceOf(alice), 1_000);
        vm.assertEq(erc20.balanceOf(bob), 1_000);
    }

    function test_transfer_zero() external {
        assertEq(erc20.balanceOf(alice), 1_000);

        vm.prank(alice);
        erc20.transfer(bob, 0);

        assertEq(erc20.balanceOf(alice), 1_000);
        assertEq(erc20.balanceOf(bob), 1_000);
    }

    function test_approve_and_transferFrom_success() external {
        vm.prank(alice);
        erc20.approve(bob, 100);

        vm.prank(bob);
        erc20.transferFrom(alice, carol, 30);

        assertEq(erc20.balanceOf(alice), 970);
        assertEq(erc20.balanceOf(bob), 1_000);
        assertEq(erc20.balanceOf(carol), 1_030);
        assertEq(erc20.allowance(alice, bob), 70);
    }

    function test_no_approve() external {
        vm.prank(bob);
        vm.expectRevert("Not Enough Allowance");
        erc20.transferFrom(alice, carol, 30);
    }

    function test_overwrite_approve() external {
        vm.startPrank(alice);
        erc20.approve(bob, 100);
        assertEq(erc20.allowance(alice, bob), 100);

        erc20.approve(bob, 50);
        assertEq(erc20.allowance(alice, bob), 50);
    }
}
