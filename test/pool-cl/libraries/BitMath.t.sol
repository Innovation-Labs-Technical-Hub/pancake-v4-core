// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {BitMath} from "../../../src/pool-cl/libraries/BitMath.sol";

contract BitMathTest is Test {
    function testMostSignificantBitZero() public {
        vm.expectRevert();
        BitMath.mostSignificantBit(0);
    }

    function testMostSignificantBitOne() public pure {
        assertEq(BitMath.mostSignificantBit(1), 0);
    }

    function testMostSignificantBitTwo() public pure {
        assertEq(BitMath.mostSignificantBit(2), 1);
    }

    function testMostSignificantBitPowersOfTwo() public pure {
        for (uint256 i = 0; i < 255; i++) {
            uint256 x = 1 << i;
            assertEq(BitMath.mostSignificantBit(x), i);
        }
    }

    function testMostSignificantBitMaxUint256() public pure {
        assertEq(BitMath.mostSignificantBit(type(uint256).max), 255);
    }

    function testMostSignificantBit(uint256 x) public pure {
        vm.assume(x != 0);
        assertEq(BitMath.mostSignificantBit(x), mostSignificantBitReference(x));
    }

    function testMsbGas() public {
        vm.startSnapshotGas("mostSignificantBitSmallNumber");
        BitMath.mostSignificantBit(3568);
        vm.stopSnapshotGas();

        vm.startSnapshotGas("mostSignificantBitMaxUint128");
        BitMath.mostSignificantBit(type(uint128).max);
        vm.stopSnapshotGas();

        vm.startSnapshotGas("mostSignificantBitMaxUint256");
        BitMath.mostSignificantBit(type(uint256).max);
        vm.stopSnapshotGas();
    }

    function testLeastSignificantBitZero() public {
        vm.expectRevert();
        BitMath.leastSignificantBit(0);
    }

    function testLeastSignificantBitOne() public pure {
        assertEq(BitMath.leastSignificantBit(1), 0);
    }

    function testLeastSignificantBitTwo() public pure {
        assertEq(BitMath.leastSignificantBit(2), 1);
    }

    function testLeastSignificantBitPowersOfTwo() public pure {
        for (uint256 i = 0; i < 255; i++) {
            uint256 x = 1 << i;
            assertEq(BitMath.leastSignificantBit(x), i);
        }
    }

    function testLeastSignificantBitMaxUint256() public pure {
        assertEq(BitMath.leastSignificantBit(type(uint256).max), 0);
    }

    function testLeastSignificantBit(uint256 x) public pure {
        vm.assume(x != 0);
        assertEq(BitMath.leastSignificantBit(x), leastSignificantBitReference(x));
    }

    function testLsbGas() public {
        vm.startSnapshotGas("leastSignificantBitSmallNumber");
        BitMath.leastSignificantBit(3568);
        vm.stopSnapshotGas();

        vm.startSnapshotGas("leastSignificantBitMaxUint128");
        BitMath.leastSignificantBit(type(uint128).max);
        vm.stopSnapshotGas();

        vm.startSnapshotGas("leastSignificantBitMaxUint256");
        BitMath.leastSignificantBit(type(uint256).max);
        vm.stopSnapshotGas();
    }

    function mostSignificantBitReference(uint256 x) private pure returns (uint256) {
        uint256 i = 0;
        while ((x >>= 1) > 0) {
            ++i;
        }
        return i;
    }

    function leastSignificantBitReference(uint256 x) private pure returns (uint256) {
        require(x > 0, "BitMath: zero has no least significant bit");

        uint256 i = 0;
        while ((x >> i) & 1 == 0) {
            ++i;
        }
        return i;
    }
}
