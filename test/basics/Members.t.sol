// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../../src/basics/Members.sol";

contract MembersTest is Test {
    Members members;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address carol = makeAddr("carol");

    function setUp() external {
        members = new Members();

        _joinAs(alice);
        _joinAs(bob);
        _joinAs(carol);
    }

    function test_aliceCall() external {
        vm.startPrank(alice);
        members.addScore(50);
        members.join();
        vm.stopPrank();

        assertEq(members.memberList(3), alice);
        (uint256 score,) = members.members(alice);
        assertEq(score, 0);
        assertEq(members.count(), 4);
    }

    function test_removeWithDelete() external {
        members.removeWithDelete(1);
        assertEq(address(0), members.memberList(1));
        assertEq(members.count(), 3);
    }

    function test_removeWithSwapPop() external {
        members.removeWithSwapPop(0);
        assertEq(members.count(), 2);
        assertEq(members.memberList(0), carol);
        assertEq(members.memberList(1), bob);
    }

    function _joinAs(address who) internal {
        vm.prank(who);
        members.join();
    }
}

