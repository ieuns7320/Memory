// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AdminBox {
    address public owner;
    uint256 public config;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier onlyOwnerSilent() {
        if (msg.sender == owner) {
            _;
        }
    }

    function setConfig(uint256 v) external onlyOwner {
        config = v;
    }

    function setConfigSilent(uint256 v) external onlyOwnerSilent {
        config = v;
    }
}