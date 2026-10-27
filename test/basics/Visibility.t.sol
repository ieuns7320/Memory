// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../../src/basics/Visibility.sol";

contract Visibility is Test {
    Parent parent;
    Child child;

    function setUp() external {
        parent = new Parent();
        child = new Child();
    }

    function test_callParentFunc() external {
        parent.pubF();
        parent.extF();
        // parent.intF();
        // parent.privF();
    }
}
