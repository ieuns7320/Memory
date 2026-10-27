// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Members {
    struct Member {
        uint256 score;
        bool active;
    }

    mapping(address => Member) public members;
    address[] public memberList;

    function join() external {
        members[msg.sender] = Member({score: 0, active: true});
        memberList.push(msg.sender);
    }

    function addScore(uint256 s) external {
        members[msg.sender].score += s;
    }

    function removeWithDelete(uint256 i) external {
        delete memberList[i];
    }

    function removeWithSwapPop(uint256 i) external {
        memberList[i] = memberList[memberList.length - 1];
        memberList.pop();
    }

    function count() external view returns (uint256) {
        return memberList.length;
    }
}