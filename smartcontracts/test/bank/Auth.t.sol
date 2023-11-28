// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {BankSetup} from "./Bank.t.sol";
import {Errors} from "../../src/bank/Bank.Errors.sol";

contract AuthTest is BankSetup {
    function setUp() public override {
        BankSetup.setUp();
    }

    function test_cannot_create_employee() public {
        address testEmployee = address(1);
        uint256 testBudge = 2 * 10e18;
        address unauthorized = address(1);
        uint256 testLocktime = block.number + 100;

        vm.prank(address(unauthorized));
        vm.expectRevert(Errors.Unauthorized.selector);
        bank.createEmployee(testEmployee, testBudge, testLocktime);
    }

    function test_cannot_update_nonexistent_employee() public {
        address testEmployee = address(1);
        uint256 newBudge = 3 * 10e18;
        uint256 newLocktime = block.number + 200;

        vm.prank(controller);
        vm.expectRevert(Errors.EmployeeNotFound.selector);
        bank.updateEmployee(testEmployee, newBudge, newLocktime);
    }

    function test_cannot_create_existing_employee() public {
        address testEmployee = address(1);
        uint256 testBudge = 2 * 10e18;
        uint256 testLocktime = block.number + 100;

        vm.prank(controller);
        bank.createEmployee(testEmployee, testBudge, testLocktime);

        vm.prank(controller);
        vm.expectRevert(Errors.EmployeeAlreadyAdd.selector);
        bank.createEmployee(testEmployee, testBudge, testLocktime);
    }

    function test_cannot_create_employee_low_salaryt() public {
        address testEmployee = address(1);
        uint256 testBudge = 0.5 * 10e18;
        uint256 testLocktime = block.number + 100;

        vm.prank(controller);
        vm.expectRevert(Errors.SalaryTooLow.selector);
        bank.createEmployee(testEmployee, testBudge, testLocktime);
    }

    function test_cannot_create_employee_zero_address() public {
        uint256 testBudge = 2 * 10e18;
        uint256 testLocktime = block.number + 100;

        vm.prank(controller);
        vm.expectRevert(Errors.ZeroAddress.selector);
        bank.createEmployee(address(0), testBudge, testLocktime);
    }

    function test_cannot_create_employee_low_locktime() public {
        address testEmployee = address(1);
        uint256 testBudge = 2 * 10e18;
        uint256 testLocktime = block.number;

        vm.prank(controller);
        vm.expectRevert(Errors.LocktimeTooLow.selector);
        bank.createEmployee(testEmployee, testBudge, testLocktime);
    }
}
