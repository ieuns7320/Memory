// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library SafeCastLite {
    error Overflow(uint256 value);

    function toUint8(uint256 x) internal pure returns (uint8) {
        if (x > type(uint8).max) revert Overflow(x);
        return uint8(x);
    }
}

contract Inventory {
    using SafeCastLite for uint256;

    uint8 public qty;

    function setQtyUnsafe(uint256 q) external {
        qty = uint8(q);
    }

    function setQtySafe(uint256 q) external {
        qty = q.toUint8();
    }
}
