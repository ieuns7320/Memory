// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Parent {
    function pubF() public pure returns (uint256) {
        return 1;
    }

    function extF() external pure returns (uint256) {
        return 2;
    }

    function intF() internal pure returns (uint256) {
        return 3;
    }

    function privF() private pure returns (uint256) {
        return 4;
    }

    function fromInside() public view returns (uint256 s) {
        s += pubF();
        // s += extF();
        s += this.extF();
        s += intF();
        s += privF();
    }
}

contract Child is Parent {
    function fromChild() public pure returns (uint256 s) {
        s += pubF();
        s += intF();
        // s += privF();
    }
}
