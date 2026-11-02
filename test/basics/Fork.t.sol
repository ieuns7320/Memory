// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address) external view returns (uint256);
    function symbol() external view returns (string memory);
}

contract ForkTest is Test {
    // 메인넷 USDC 주소
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    function setUp() external {
        vm.createSelectFork(vm.envString("RPC_URL"));
    }

    function test_fork_readUSDC() external view {
        IERC20 usdc = IERC20(USDC);
        uint256 supply = usdc.totalSupply();

        console.log("USDC symbol:", usdc.symbol());
        console.log("USDC totalSupply:", supply);

        assertGt(supply, 0); // 총 발행량이 0보다 크다.
    }
}
