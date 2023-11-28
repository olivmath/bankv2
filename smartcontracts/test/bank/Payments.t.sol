// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {BankSetup} from "./Bank.t.sol";
import {console2} from "forge-std/console2.sol";

contract PaymentsTest is BankSetup {
    function setUp() public override {
        BankSetup.setUp();
    }

    function test_simple_employee_payment() public {
        uint256 salary1 = 1 * 10e18;
        uint256 locktime1 = 100;

        vm.prank(controller);
        bank.createEmployee(bob, salary1, locktime1);

        vm.prank(controller);
        token.transfer(address(bank), 1 * 10e18);

        vm.roll(101);
        vm.prank(controller);
        assertTrue(bank.payAllEmployees());

        assertEq(token.balanceOf(bob), 1 * 10e18);
    }

    function test_complex_employee_payment() public {
        uint256 salary = 1 * 10e18;
        uint256 locktime1 = 100;

        vm.startPrank(controller);
        bank.createEmployee(bob, salary, locktime1);
        bank.createEmployee(alice, salary, locktime1);
        bank.createEmployee(eve, salary * 3, locktime1);
        bank.deleteEmployee(alice);

        token.transfer(address(bank), 10 * 10e18);

        assertEq(bank.getTotalEmployeeCost(), 4 * 10e18);

        vm.roll(101);
        assertTrue(bank.payAllEmployees());
        vm.stopPrank();

        assertEq(token.balanceOf(bob), 1 * 10e18);
        assertEq(token.balanceOf(eve), 3 * 10e18);
        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(address(bank)), 6 * 10e18);
    }

    function test_employee_payments_with_different_dates() public {
        uint256 salary = 1 * 10e18;
        uint256 locktime1 = 100;
        uint256 locktime2 = 800;
        uint256 locktime3 = 300;

        vm.startPrank(controller);
        bank.createEmployee(bob, salary, locktime1);
        bank.createEmployee(alice, salary, locktime2);
        bank.createEmployee(eve, salary, locktime3);

        token.transfer(address(bank), 10 * 10e18);

        assertEq(bank.getTotalEmployeeCost(), 3 * 10e18);

        vm.roll(101);
        assertTrue(bank.payAllEmployees());

        assertEq(token.balanceOf(address(bank)), 9 * 10e18);
        assertEq(token.balanceOf(bob), 1 * 10e18);
        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(eve), 0);

        vm.roll(301);
        assertTrue(bank.payAllEmployees());

        assertEq(token.balanceOf(address(bank)), 7 * 10e18);
        assertEq(token.balanceOf(bob), 2 * 10e18);
        assertEq(token.balanceOf(eve), 1 * 10e18);
        assertEq(token.balanceOf(alice), 0);

        vm.roll(801);
        assertTrue(bank.payAllEmployees());

        assertEq(token.balanceOf(address(bank)), 4 * 10e18);
        assertEq(token.balanceOf(alice), 1 * 10e18);
        assertEq(token.balanceOf(bob), 3 * 10e18);
        assertEq(token.balanceOf(eve), 2 * 10e18);

        vm.stopPrank();
    }

    function test_employee_payments_without_balance() public {
        uint256 salary = 1 * 10e18;
        uint256 locktime1 = 100;
        uint256 locktime2 = 800;
        uint256 locktime3 = 300;

        vm.startPrank(controller);
        bank.createEmployee(bob, salary, locktime1);
        bank.createEmployee(alice, salary, locktime2);
        bank.createEmployee(eve, salary, locktime3);

        assertEq(bank.getTotalEmployeeCost(), 3 * 10e18);

        vm.roll(101);
        assertTrue(bank.payAllEmployees());

        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), 0);
        assertEq(token.balanceOf(eve), 0);
        assertEq(bank.getEmployee(bob).bonus, 1 * 10e18);
        assertEq(bank.getEmployee(alice).bonus, 0);
        assertEq(bank.getEmployee(eve).bonus, 0);

        bank.getAllEmployees();
        assertEq(bank.getTotalEmployeeCost(), 4 * 10e18);

        vm.roll(301);
        assertTrue(bank.payAllEmployees());

        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), 0);
        assertEq(token.balanceOf(eve), 0);
        assertEq(bank.getEmployee(bob).bonus, 2 * 10e18);
        assertEq(bank.getEmployee(eve).bonus, 1 * 10e18);
        assertEq(bank.getEmployee(alice).bonus, 0);

        bank.getAllEmployees();
        assertEq(bank.getTotalEmployeeCost(), 6 * 10e18);

        vm.roll(801);
        assertTrue(bank.payAllEmployees());

        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), 0);
        assertEq(token.balanceOf(eve), 0);
        assertEq(bank.getEmployee(bob).bonus, 3 * 10e18);
        assertEq(bank.getEmployee(eve).bonus, 2 * 10e18);
        assertEq(bank.getEmployee(alice).bonus, 1 * 10e18);

        bank.getAllEmployees();
        assertEq(bank.getTotalEmployeeCost(), 9 * 10e18);

        vm.stopPrank();
    }
}
