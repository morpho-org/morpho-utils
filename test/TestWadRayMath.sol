// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {WadRayMathMock} from "./mocks/WadRayMathMock.sol";
import {WadRayMathRef} from "./references/WadRayMathRef.sol";
import "forge-std/Test.sol";

contract TestWadRayMath is Test {
    uint256 public constant WAD = 1e18;
    uint256 public constant HALF_WAD = WAD / 2;
    uint256 public constant RAY = 1e27;
    uint256 public constant HALF_RAY = RAY / 2;
    uint256 public constant WAD_RAY_RATIO = 1e9;
    uint256 public constant HALF_WAD_RAY_RATIO = WAD_RAY_RATIO / 2;
    uint256 public constant MAX_UINT256_MINUS_HALF_WAD = type(uint256).max - HALF_WAD;
    uint256 public constant MAX_UINT256_MINUS_HALF_RAY = type(uint256).max - HALF_RAY;

    WadRayMathMock mock;
    WadRayMathRef ref;

    function setUp() public {
        mock = new WadRayMathMock();
        ref = new WadRayMathRef();
    }

    /// TESTS ///

    function testWadMul(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= MAX_UINT256_MINUS_HALF_WAD / y);

        assertEq(mock.wadMul(x, y), ref.wadMul(x, y));
    }

    function testWadMulOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > MAX_UINT256_MINUS_HALF_WAD / y);

        vm.expectRevert();
        mock.wadMul(x, y);
    }

    function testWadDiv(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (type(uint256).max - y / 2) / WAD);

        assertEq(mock.wadDiv(x, y), ref.wadDiv(x, y));
    }

    function testWadDivOverflow(uint256 x, uint256 y) public {
        vm.assume(x > (type(uint256).max - y / 2) / WAD);

        vm.expectRevert();
        mock.wadDiv(x, y);
    }

    function testWadDivByZero(uint256 x, uint256 y) public {
        vm.assume(y == 0);

        vm.expectRevert();
        mock.wadDiv(x, y);
    }

    function testRayMul(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= MAX_UINT256_MINUS_HALF_RAY / y);

        assertEq(mock.rayMul(x, y), ref.rayMul(x, y));
    }

    function testRayMulOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > MAX_UINT256_MINUS_HALF_RAY / y);

        vm.expectRevert();
        mock.rayMul(x, y);
    }

    function testRayDiv(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (type(uint256).max - y / 2) / RAY);

        assertEq(mock.rayDiv(x, y), ref.rayDiv(x, y));
    }

    function testRayDivOverflow(uint256 x, uint256 y) public {
        vm.assume(x > (type(uint256).max - y / 2) / RAY);

        vm.expectRevert();
        mock.rayDiv(x, y);
    }

    function testRayDivByZero(uint256 x, uint256 y) public {
        vm.assume(y == 0);

        vm.expectRevert();
        mock.rayDiv(x, y);
    }

    function testRayToWad(uint256 x) public {
        assertEq(mock.rayToWad(x), ref.rayToWad(x));
    }

    function testWadToRay(uint256 x) public {
        vm.assume(x <= type(uint256).max / WAD_RAY_RATIO);

        assertEq(mock.wadToRay(x), ref.wadToRay(x));
    }

    function testWadToRayOverflow(uint256 x) public {
        vm.assume(x > type(uint256).max / WAD_RAY_RATIO);

        vm.expectRevert();
        mock.wadToRay(x);
    }
}
