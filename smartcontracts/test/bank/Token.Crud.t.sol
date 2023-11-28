// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {BankSetup} from "./Bank.t.sol";

contract TokenCrudTest is BankSetup {
    function setUp() public override {
        BankSetup.setUp();
    }

    function test_SetToken() public {
        address newToken = address(2);

        vm.prank(controller);
        bank.setToken(newToken);

        assertEq(address(bank.getToken()), newToken);
    }

    function test_deposit() public {
        vm.prank(controller);
        token.transfer(address(bank), 10 * 10e18);
        assertEq(bank.getBalance(), token.balanceOf(address(bank)));
    }

    function test_get_total_cost() public {
        uint256 testBudge = 1 * 10e18;
        uint256 testLocktime = block.number + 100;

        vm.startPrank(controller);
        bank.createEmployee(address(0x1), testBudge, testLocktime);
        bank.createEmployee(address(0x2), testBudge * 2, testLocktime);
        bank.createEmployee(address(0x3), testBudge * 9, testLocktime);
        vm.stopPrank();

        assertEq(bank.getTotalEmployeeCost(), 12 * 10e18);
    }
}
