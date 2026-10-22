//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {stdError} from "forge-std/StdError.sol";

contract Types is Test {
    Calculator calculator;

    function setUp() external {
        calculator = new Calculator();
    }

    function test_Revertone() public {
        vm.expectRevert(stdError.arithmeticError);
        calculator.addOne(255);
    }

    function test_addOne_normal() public view {
        assertEq(calculator.addOne(254), 255);
    }

    function test_two() public pure {
        uint256 big = 300;
        uint8 r2 = uint8(big);
        vm.assertEq(r2, 44);
    }

    function test_three() public pure {
        uint8 b = 0;
        uint8 r3;
        unchecked {
            r3 = b - 1;
        }
        vm.assertEq(r3, 255);
    }
}

contract Calculator {
    function addOne(uint8 x) external pure returns (uint8) {
        return x + 1;
    }
}
