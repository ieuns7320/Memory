// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Wallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function withdrawTxOrigin() external view returns (bool) {
        require(tx.origin == owner, "not owner");
        return true;
    }

    function withdrawMsgSender() external view returns (bool) {
        require(msg.sender == owner, "not owner");
        return true;
    }
}

contract Attack {
    Wallet public wallet;

    constructor(Wallet w) {
        wallet = w;
    }

    function hack() external view returns (bool) {
        return wallet.withdrawTxOrigin();
    }

    function hackMsgSender() external view returns (bool) {
        return wallet.withdrawMsgSender(); // msg.sender 버전 공격 시도
    }
}
