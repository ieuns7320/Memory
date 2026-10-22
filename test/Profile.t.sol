//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Profile} from "../src/Profile.sol";

contract ProfileTest is Test {
    Profile profile;
    address alice;
    uint256 alicePk;

    function setUp() public {
        (alice, alicePk) = makeAddrAndKey("alice");
        vm.deal(alice, 10 ether);
        profile = new Profile();
    }

    function test_banWithMemory_doesNotPersist() public {
        vm.startPrank(alice);
        profile.banWithMemory();
        (, bool banned) = profile.users(alice);
        vm.assertFalse(banned, "memory copy must NOT persist");
        vm.stopPrank();
    }

    function test_banWithStorage_persists() public {
        vm.startPrank(alice);
        profile.banWithStorage();
        (, bool banned) = profile.users(alice);
        vm.assertTrue(banned, "storage pointer must persist");
        vm.stopPrank();
    }

    function test_sumCalldata() public {
        uint256 t = profile.sumCalldata(_makeArray(50));
        assertEq(t, 1275);
    }

    function test_sumMemory() public {
        uint256 t = profile.sumMemory(_makeArray(50));
        assertEq(t, 1275);
    }

    function _makeArray(uint256 n) internal pure returns (uint256[] memory) {
        uint256[] memory xs = new uint256[](n);
        for (uint256 i = 0; i < n; i++) {
            xs[i] = i + 1;
        }

        return xs;
    }
}

// [1]
// banWithMemory()와 banWithStorage()를 각각 호출한 뒤
// users(address)로 banned 값을 확인해서,
// 실제로 저장되는 쪽이 어느 것인지 테스트로 증명해.

// [2]
// 같은 배열(예: 원소 50개)로 sumCalldata와 sumMemory를 호출하고
// --gas-report로 가스를 비교해.
