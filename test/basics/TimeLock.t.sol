// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../../src/basics/TimeLock.sol";

contract TimeLockTest is Test {
    address owner = makeAddr("owner");
    TimeLock timelock;

    function setUp() external {
        vm.deal(owner, 1 ether);
        vm.prank(owner);
        timelock = new TimeLock{value: 1 ether}(100);
    }

    function test_withdraw_afterUnlock_succeeds() external {
        vm.warp(timelock.unlockTime() + 1);
        timelock.withdraw();
        assertEq(owner.balance, 1 ether);
    }

    function test_withdraw_atExactUnlock_succeeds() external {
        vm.warp(timelock.unlockTime());
        timelock.withdraw();
        assertEq(owner.balance, 1 ether);
    }

    function test_withdraw_beforeUnlock_reverts() external {
        vm.expectRevert(abi.encodeWithSelector(TimeLock.TooEarly.selector, block.timestamp, timelock.unlockTime()));
        timelock.withdraw();
    }
}
