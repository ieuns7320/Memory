// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {
    uint256 public count; // storage에 저장됨 (CA만 가짐)
    address public lastCaller;

    function increment() external {
        count += 1;
        lastCaller = msg.sender; // 나를 "직접" 호출한 주소
    }
}

// 다른 컨트랙트를 대신 호출해 주는 중계 컨트랙트
contract Relay {
    function poke(Counter c) external {
        c.increment(); // CA가 CA를 호출 -> Counter 입장에서 msg.sender는 Relay
    }
}
