// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Profile {
    struct User {
        uint256 score;
        bool banned;
    }
    mapping(address => User) public users;

    function setScore(uint256 s) external {
        users[msg.sender].score = s;
    }

    function banWithMemory() external view {
        User memory u = users[msg.sender];
        u.banned = true;
    }

    function banWithStorage() external {
        User storage u = users[msg.sender];
        u.banned = true;
    }

    function sumCalldata(uint256[] calldata xs) external pure returns (uint256 t) {
        for (uint256 i = 0; i < xs.length; i++) {
            t += xs[i];
        }
    }

    function sumMemory(uint256[] memory xs) external pure returns (uint256 t) {
        for (uint256 i = 0; i < xs.length; i++) {
            t += xs[i];
        }
    }
}
