// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../../src/basics/Receivers.sol";

contract ReceiversTest is Test {
    Both both;
    OnlyFallback only;
    Nothing nothing;

    function setUp() external {
        both = new Both();
        only = new OnlyFallback();
        nothing = new Nothing();

        vm.deal(address(this), 10 ether);
    }

    function est_emptyCalldata_triggersReceive() external {
        (bool ok,) = address(both).call{value: 1 ether}("");

        assertTrue(ok);
        assertEq(both.receiveCount(), 1);
        assertEq(both.fallbackCount(), 0);
        assertEq(address(both).balance, 1 ether);
    }

    function ttest_unknownSelector_triggersFallback() external {
        (bool ok,) = address(both).call(abi.encodeWithSignature("hello()"));
        assertTrue(ok);
        assertEq(both.lastData(), abi.encodeWithSignature("hello()"));
        assertEq(both.receiveCount(), 0);
        assertEq(both.fallbackCount(), 1);
    }

    function test_noReceiveNoFallback_rejectsEth() external {
        (bool ok,) = address(nothing).call{value: 1 ether}("");
        assertFalse(ok);
    }

    function test_onlyFallback_acceptsEth() external {
        (bool ok,) = address(only).call{value: 1 ether}("");

        assertTrue(ok);
        assertEq(only.fallbackCount(), 1);
    }

    function test_send_2300Stipend_cannotWriteStorage() external {
        bool ok = payable(address(both)).send(1 ether);
        assertFalse(ok);
        assertEq(both.receiveCount(), 0);
        assertEq(address(both).balance, 0);
    }
}
