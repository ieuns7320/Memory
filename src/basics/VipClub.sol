// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPoints {
    function balanceOf(address user) external view returns (uint256);
}

contract RealPoints is IPoints {
    address public owner;
    mapping(address => uint256) private _balances;

    constructor() {
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "not owner");
        _balances[to] += amount;
    }

    function balanceOf(address user) external view returns (uint256) {
        return _balances[user];
    }
}

contract VipClubVulnerable {
    error NotEnoughPoints();
    mapping(address => bool) public isVip;

    function claimVip(address pointsToken) external {
        if (IPoints(pointsToken).balanceOf(msg.sender) < 100) revert NotEnoughPoints();
        isVip[msg.sender] = true;
    }
}

contract VipClub {
    IPoints public immutable points;
    error NotEnoughPoints();
    error ZeroAddress();

    constructor(IPoints _points) {
        if (address(_points) == address(0)) revert ZeroAddress();
        points = _points;
    }

    mapping(address => bool) public isVip;

    function claimVip() external {
        if (points.balanceOf(msg.sender) < 100) revert NotEnoughPoints();
        isVip[msg.sender] = true;
    }
}
