// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../../src/basics/SafeCastLite.sol";

contract SafeCastLiteTest is Test {
    Inventory inventory;

    function setUp() external {
        inventory = new Inventory();
    }

    function test_setQtyUnsafe() external {
        inventory.setQtyUnsafe(300);
        assertEq(inventory.qty(), 44);
    }

    function test_setQtySafe() external {
        inventory.setQtySafe(255);
        assertEq(inventory.qty(), 255);
    }

    function test_setQtySafe_expectRevert() external {
        vm.expectRevert(abi.encodeWithSelector(SafeCastLite.Overflow.selector, 256));
        inventory.setQtySafe(256);
    }
}
