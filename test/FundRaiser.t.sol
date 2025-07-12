// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Vm} from "forge-std/Vm.sol";
import {Test} from "forge-std/Test.sol";

import {FundRaiser} from "../src/FundRaiser.sol";

contract FundRaiserTest is Test {
    FundRaiser fundRaiser;

    address admin;
    address minter;

    function setUp() public {
        vm.createSelectFork("https://gateway.tenderly.co/public/sepolia");

        admin = makeAddr("admin");

        fundRaiser = new FundRaiser();
    }

    function test_DepositETH() public {
        // Make user holding 2 ETH.
        address user = makeAddr("user");
        vm.deal(user, 2 ether);

        // Let user deposit 1 ETH (2k+ USD) into fundRaiser.
        vm.prank(user);
        (bool successfulDeposit,) = address(fundRaiser).call{value: 1 ether}("");
        require(successfulDeposit, "Deposit failed");

        // User cannot deposit any more funds after goal is reached into fundraiser
        (bool ok,) = address(fundRaiser).call{value: 1 ether}("");
        require(!ok, "Deposit should have failed");
    }
}