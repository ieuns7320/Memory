// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ledger {
    mapping(address => uint256) public balanceOf;
    uint256 public totalSupply;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
        totalSupply += amount;
    }

    function transfer(address from, address to, uint256 amount) external {
        require(balanceOf[from] >= amount, "insufficient");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }

    function transferBuggy(address from, address to, uint256 amount) external {
        uint256 fromBal = balanceOf[from];
        uint256 toBal = balanceOf[to];
        require(fromBal >= amount, "insufficient");
        balanceOf[from] = fromBal - amount;
        balanceOf[to] = toBal + amount;
    }
}

