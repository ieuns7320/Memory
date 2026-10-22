//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Counter, Relay} from "../src/Counter.sol";

contract AccountTest is Test {
    Counter counter;
    Relay relay;
    address alice;
    uint256 alicePk;

    function setUp() public {
        (alice, alicePk) = makeAddrAndKey("alice"); // EOA: 개인 키 + 주소 쌍
        vm.deal(alice, 10 ether);
        counter = new Counter(); // CA 배포
        relay = new Relay();
    }

    // 1. EOA는 코드가 없고, CA는 코드가 있다.
    function test_codeDifference() public view {
        assertEq(alice.code.length, 0);
        assertGt(address(counter).code.length, 0);
    }

    // 2. EOA 주소는 개인 키에서 결정된다.
    function test_eoaAddressFromKey() public view {
        assertEq(vm.addr(alicePk), alice);
    }

    // 3. CA 주소는 배포자 주소 + nonce로 결정된다. (CREATE)
    function test_contractAddressPrediction() public {
        address predicted = computeCreateAddress(address(this), vm.getNonce(address(this)));
        Counter c = new Counter();
        assertEq(address(c), predicted);
    }

    // 4. 호출 체인에서 msg.sender가 바뀐다.
    function test_callChain() public {
        vm.prank(alice); // 다음 호출의 msg.sender를 alice로 설정
        counter.increment();
        assertEq(counter.lastCaller(), alice);

        vm.prank(alice);
        relay.poke(counter); // alice -> Relay -> Counter
        assertEq(counter.lastCaller(), address(relay)); // alice가 아니다.
    }
}
