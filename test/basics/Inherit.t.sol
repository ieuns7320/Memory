// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../../src/basics/Inherit.sol";

contract InheritTest is Test {
    Base base;
    ChildA child_a;
    ChildB child_b;
    address bob = makeAddr("bob");

    function setUp() external {
        child_a = new ChildA();
        child_b = new ChildB();
    }

    function test_childASetValue() external {
        assertTrue(child_a.owner() != bob);
        vm.prank(bob);
        child_a.setValue(5);
        assertEq(child_a.value(), 10);
    }

    function test_childBSetValue() external {
        vm.prank(bob);
        vm.expectRevert(abi.encodeWithSelector(Base.NotOwner.selector, bob));
        child_b.setValue(5);
    }

    function test_childBSetValueOwner() external {
        child_b.setValue(5);
        assertEq(child_b.value(), 5);
        assertEq(child_b.extra(), 5);
    }
}
