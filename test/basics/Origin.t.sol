// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../../src/basics/Origin.sol";

contract OriginTest is Test {
    address owner = makeAddr("owner");
    Wallet wallet;
    Attack attack;

    function setUp() external {
        vm.prank(owner);
        wallet = new Wallet();
        attack = new Attack(wallet);
    }

    function test_txOrigin_phishing_succeeds() external {
        assertEq(wallet.owner(), owner);
        vm.prank(owner, owner);
        assertTrue(attack.hack());
    }

    function test_msgSender_phishing_reverts() external {
        assertEq(wallet.owner(), owner);
        vm.prank(owner, owner);
        vm.expectRevert("not owner");
        attack.hackMsgSender();
    }

    function test_msgSender_directCall_succeeds() external {
        assertEq(wallet.owner(), owner);
        vm.prank(owner);
        wallet.withdrawMsgSender();
    }
}
