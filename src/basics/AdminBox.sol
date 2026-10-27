// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AdminBox {
    event ConfigChanged(address indexed by, uint256 oldValue, uint256 newValue);
    error NotOwner(address caller);
    error InvalidConfig(uint256 v);

    address public owner;
    uint256 public config;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner(msg.sender);
        _;
    }

    modifier onlyOwnerSilent() {
        if (msg.sender == owner) {
            _;
        }
    }

    modifier outOfScopeConfig(uint256 v) {
        if (v > 100) revert InvalidConfig(v);
        _;
    }

    function setConfig(uint256 v) external onlyOwner outOfScopeConfig(v) {
        uint256 old = config;
        config = v;
        emit ConfigChanged(msg.sender, old, v);
    }

    function setConfigSilent(uint256 v) external onlyOwnerSilent outOfScopeConfig(v) {
        config = v;
    }
}
