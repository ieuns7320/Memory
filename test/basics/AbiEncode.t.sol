// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";

contract AbiEncodeTest is Test {
    function setX(uint256) external {} // 선택자를 얻기 위한 더미 함수

    function test_signatureEqualsSelector() external pure {
        bytes memory a = abi.encodeWithSignature("setX(uint256)", 7);
        bytes memory b = abi.encodeWithSelector(this.setX.selector, 7);
        assertEq(a, b);
    }

    function test_calldataLayout() external pure {
        bytes memory data = abi.encodeWithSignature("setX(uint256)", 7);
        assertEq(data.length, 36); // 왜 36일까?
    }

    function test_encodePacked_hashCollision_vs_encode() external pure {
        bytes32 packed1 = keccak256(abi.encodePacked("a", "bc"));
        bytes32 packed2 = keccak256(abi.encodePacked("ab", "c"));

        bytes32 encoded1 = keccak256(abi.encode("a", "bc"));
        bytes32 encoded2 = keccak256(abi.encode("ab", "c"));

        assertEq(packed1, packed2);
        assertTrue(encoded1 != encoded2);
    }
}

