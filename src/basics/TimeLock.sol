// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimeLock {
    error TooEarly(uint256 nowTs, uint256 unlockTs);

    address public owner;
    uint256 public unlockTime;

    constructor(uint256 lockSeconds) payable {
        owner = msg.sender;
        unlockTime = block.timestamp + lockSeconds;
    }

    function withdraw() external {
        if (block.timestamp < unlockTime) revert TooEarly(block.timestamp, unlockTime);
        payable(owner).transfer(address(this).balance);
    }
}
