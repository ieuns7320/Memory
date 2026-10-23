// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Test } from "forge-std/Test.sol";
import { AdminBox } from "../../src/basics/AdminBox.sol";

contract AdminBoxTest is Test {
    AdminBox adminbox;
    address bob = makeAddr("bob");

    function setUp() external {
        adminbox = new AdminBox();
    }

    function test_setConfigOwner() external {
        adminbox.setConfig(5);
        assertEq(adminbox.config(), 5);
    }


    function test_setConfig() external {
        vm.prank(bob);
        vm.expectRevert(bytes("not owner"));
        adminbox.setConfig(5);
        assertEq(adminbox.config(), 0);
    }

    function test_setConfigSilentOwner() external {
        adminbox.setConfigSilent(15);
        assertEq(adminbox.config(), 15);
    }

    function test_setConfigSilent() external {
        vm.prank(bob);
        adminbox.setConfigSilent(15);
        assertEq(adminbox.config(), 0);
    }
}