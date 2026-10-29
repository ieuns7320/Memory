// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Logic {
    uint256 public num;
    address public sender;

    function setNum(uint256 n) external {
        num = n;
        sender = msg.sender;
    }
}

contract SameLayout {
    uint256 public num;
    address public sender;

    function callSetNum(address logic, uint256 n) external returns (bool ok) {
        (ok,) = logic.call(abi.encodeWithSignature("setNum(uint256)", n));
    }

    function delegateSetNum(address logic, uint256 n) external returns (bool ok) {
        (ok,) = logic.delegatecall(abi.encodeWithSignature("setNum(uint256)", n));
    }
}

contract WrongLayout {
    address public owner;
    uint256 public num;

    constructor() {
        owner = msg.sender;
    }

    function delegateSetNum(address logic, uint256 n) external returns (bool ok) {
        (ok,) = logic.delegatecall(abi.encodeWithSignature("setNum(uint256)", n));
    }
}
