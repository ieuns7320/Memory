// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../../src/basics/Delegate.sol";

contract DelegateTest is Test {
    address alice = makeAddr("alice");
    address attacker = makeAddr("attacker");
    Logic logic;
    SameLayout same;
    WrongLayout wronglayout;

    function setUp() external {
        logic = new Logic();
        same = new SameLayout();
        wronglayout = new WrongLayout();
    }

    function test_call_writesLogicStorage_senderIsCaller() external {
        same.callSetNum(address(logic), 7);
        assertEq(same.num(), 0);
        assertEq(logic.num(), 7);
        assertEq(logic.sender(), address(same));
    }

    function test_delegatecall_writesOwnStorage_keepsMsgSender() external {
        vm.startPrank(alice);
        same.delegateSetNum(address(logic), 7);
        assertEq(same.num(), 7);
        assertEq(same.sender(), alice);
        assertEq(logic.num(), 0);
        vm.stopPrank();
    }

    function test_delegatecall_wrongLayout_corruptsOwnerAndNum() external {
        vm.startPrank(alice);
        wronglayout.delegateSetNum(address(logic), 7);
        assertEq(wronglayout.owner(), address(7));
        assertEq(wronglayout.num(), uint256(uint160(alice)));
        vm.stopPrank();
    }

    function test_attack_storageCollision_takesOwnership() external {
        vm.startPrank(attacker);
        assertEq(wronglayout.owner(), address(this));
        wronglayout.delegateSetNum(address(logic), uint256(uint160(attacker)));
        assertEq(wronglayout.owner(), attacker);
        vm.stopPrank();
    }
}
