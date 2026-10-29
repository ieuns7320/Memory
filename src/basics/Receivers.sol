// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Both {
    uint256 public receiveCount;
    uint256 public fallbackCount;
    bytes public lastData;

    receive() external payable {
        receiveCount++;
    }

    fallback() external payable {
        fallbackCount++;
        lastData = msg.data;
    }
}

contract OnlyFallback {
    uint256 public fallbackCount;

    fallback() external payable {
        fallbackCount++;
    }
}

contract Nothing {}
