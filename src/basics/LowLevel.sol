// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Target {
    uint256 public x;

    function setX(uint256 v) external {
        x = v;
    }

    function boom() external pure {
        revert("boom");
    }
}

contract Caller {
    function callSetX(address t, uint256 v) external returns (bool ok) {
        (ok,) = t.call(abi.encodeWithSignature("setX(uint256)", v));
    }

    function callSetXTypo(address t, uint256 v) external returns (bool ok) {
        (ok,) = t.call(abi.encodeWithSignature("setX(uint)", v));
    }

    function callBoom(address t) external returns (bool ok, bytes memory data) {
        (ok, data) = t.call(abi.encodeWithSignature("boom()"));
    }
}
