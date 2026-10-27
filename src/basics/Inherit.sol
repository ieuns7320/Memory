// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Base {
    error NotOwner(address caller);

    address public owner;
    uint256 public value;

    constructor() { owner = msg.sender; }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner(msg.sender);
        _;
    }

    function setValue(uint256 v) public virtual onlyOwner {
        value = v;
    }
}

// modifier를 빠뜨리고 덮어씀
contract ChildA is Base {
    function setValue(uint256 v) public override {
        value = v * 2;
    }
}

// modifier를 붙이고, 부모 로직도 super로 재사용
contract ChildB is Base {
    uint256 public extra;

    function setValue(uint256 v) public override onlyOwner {
        super.setValue(v);
        extra = v;
    }
}
