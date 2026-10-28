// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../../src/basics/VipClub.sol";

contract FakePoints is IPoints {
    function balanceOf(address) external pure returns (uint256) {
        return 101;
    }
}

contract VipClubTest is Test {
    address attacker = makeAddr("attacker");
    address alice = makeAddr("alice");
    RealPoints realpoints;
    FakePoints fakepoints;
    VipClubVulnerable vulnerable;
    VipClub vipclub;

    function setUp() external {
        realpoints = new RealPoints(); // owner = 테스트 컨트랙트
        fakepoints = new FakePoints();
        vulnerable = new VipClubVulnerable();
        vipclub = new VipClub(realpoints);
        realpoints.mint(alice, 100);
    }

    function test_vulnerable_fakePoints_grantsVip() external {
        vm.startPrank(attacker);
        assertEq(realpoints.balanceOf(attacker), 0);
        assertEq(vulnerable.isVip(attacker), false);

        vulnerable.claimVip(address(fakepoints));

        assertEq(vulnerable.isVip(attacker), true);
        vm.stopPrank();
    }

    function test_fixed_attacker_reverts() external {
        vm.startPrank(attacker);
        assertEq(realpoints.balanceOf(attacker), 0);
        assertEq(vipclub.isVip(attacker), false);

        vm.expectRevert(VipClub.NotEnoughPoints.selector);
        vipclub.claimVip();

        assertEq(vipclub.isVip(attacker), false);
        vm.stopPrank();
    }

    function test_fixed_alice_becomesVip() external {
        vm.startPrank(alice);
        assertEq(realpoints.balanceOf(alice), 100);
        assertEq(vipclub.isVip(alice), false);

        vipclub.claimVip();

        assertEq(vipclub.isVip(alice), true);
        vm.stopPrank();
    }
}
