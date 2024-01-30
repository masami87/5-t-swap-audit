// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test } from "forge-std/Test.sol";
import { StdInvariant } from "forge-std/StdInvariant.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

import { PoolFactory } from "../../src/PoolFactory.sol";

import { TSwapPool } from "../../src/PoolFactory.sol";

contract Invariant is StdInvariant, Test {
    ERC20Mock poolToken;
    ERC20Mock weth;

    PoolFactory factory;
    TSwapPool pool;

    int256 constant STARTING_X = 100e18; // poolToken
    int256 constant STARTING_Y = 50e18; // weth

    address owner = makeAddr("owner");

    address liquidityProvider = makeAddr("liquidityProvider");

    function setUp() public {
        vm.startPrank(owner);
        poolToken = new ERC20Mock();
        weth = new ERC20Mock();
        factory = new PoolFactory(address(weth));
        pool = TSwapPool(factory.createPool(address(poolToken)));

        poolToken.mint(owner, uint256(STARTING_X));
        weth.mint(owner, uint256(STARTING_Y));

        poolToken.approve(address(pool), type(uint256).max);
        weth.approve(address(pool), type(uint256).max);

        pool.deposit(uint256(STARTING_Y), uint256(STARTING_Y), uint256(STARTING_X), uint64(block.timestamp));
        vm.stopPrank();
    }

    function statefulFazz_constantProductFormulaStaysTheSame() public { }
}
