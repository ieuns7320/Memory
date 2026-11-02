// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../../src/basics/FuzzPlayground.sol";
import {SafeCastLite} from "../../src/basics/SafeCastLite.sol";

contract FuzzPlaygroundTest is Test {
    using SafeCastLite for uint256;
    Ledger ledger;

    function setUp() external {
        ledger = new Ledger();
    }

    function testFuzz_toUint8_roundTrip(uint256 x) external pure {
        x = bound(x, 0, 255);
        assertEq(uint256(x.toUint8()), x);
    }

    function testFuzz_transfer_preservesSum(address from, address to, uint256 amount) external {
        ledger.mint(from, 1000);
        amount = bound(amount, 0, 1000);
        uint256 saved = ledger.balanceOf(from) + ledger.balanceOf(to);
        ledger.transfer(from, to, amount);
        assertEq(saved, ledger.balanceOf(from) + ledger.balanceOf(to));
    }

    function testFuzz_transferBuggy_preservesSum(address from, address to, uint256 amount) external {
        ledger.mint(from, 1000);
        amount = bound(amount, 0, 1000);
        uint256 saved = ledger.balanceOf(from) + ledger.balanceOf(to);
        ledger.transferBuggy(from, to, amount);
        assertEq(saved, ledger.balanceOf(from) + ledger.balanceOf(to));
    }
}
