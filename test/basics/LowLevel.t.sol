// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../../src/basics/LowLevel.sol";

contract LowLevelTest is Test {
    address alice = makeAddr("alice");
    Target target;
    Caller caller;

    function setUp() external {
        target = new Target();
        caller = new Caller();
    }

    function test_callSetX_succeeds_updatesTarget() external {
        bool ok = caller.callSetX(address(target), 7);
        assertEq(ok, true);
        assertEq(target.x(), 7);
    }

    function test_callBoom_doesNotRevert_returnsErrorData() external {
        (bool ok, bytes memory data) = caller.callBoom(address(target));
        assertEq(data, abi.encodeWithSignature("Error(string)", "boom"));
        assertEq(ok, false);
    }

    function test_call_toEOA_returnsTrue() external {
        assertEq(alice.code.length, 0);
        bool ok = caller.callSetX(alice, 7);
        assertEq(ok, true);
    }

    function test_callSetXTypo_wrongSelector_fails() external {
        bool ok = caller.callSetXTypo(address(target), 7);
        assertEq(ok, false);
        assertEq(target.x(), 0);
    }
}
