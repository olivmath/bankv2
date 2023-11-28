// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {BankSetup} from "./Bank.t.sol";
import {Employee} from "../../src/bank/Bank.Types.sol";

contract EmployeeCrudTest is BankSetup {
    function setUp() public override {
        BankSetup.setUp();
    }

    function test_create_employee() public {
        address testEmployee = address(1);
        uint256 testBudge = 2 * 10e18;
        uint256 testLocktime = 100;

        vm.prank(controller);
        bank.createEmployee(testEmployee, testBudge, testLocktime);

        Employee memory createdEmployee = bank.getEmployee(testEmployee);
        assertEq(createdEmployee.employee, testEmployee);
        assertEq(createdEmployee.salary, testBudge);
        assertEq(createdEmployee.locktime, testLocktime);
    }

    function test_update_employee() public {
        address testEmployee = address(1);
        uint256 testBudge = 2 * 10e18;
        uint256 testLocktime = 100;

        vm.prank(controller);
        bank.createEmployee(testEmployee, testBudge, testLocktime);

        testEmployee = address(1);
        uint256 newBudge = 3 * 10e18;
        uint256 newLocktime = 200;

        vm.prank(controller);
        bank.updateEmployee(testEmployee, newBudge, newLocktime);

        Employee memory updatedEmployee = bank.getEmployee(testEmployee);
        assertEq(updatedEmployee.salary, newBudge);
        assertEq(updatedEmployee.locktime, newLocktime);
    }

    function test_delete_employee() public {
        address testEmployee = address(1);
        uint256 testBudge = 2 * 10e18;
        uint256 testLocktime = 100;

        vm.prank(controller);
        bank.createEmployee(testEmployee, testBudge, testLocktime);

        testEmployee = address(1);

        vm.prank(controller);
        bank.deleteEmployee(testEmployee);

        Employee memory deletedEmployee = bank.getEmployee(testEmployee);
        assertEq(deletedEmployee.employee, address(0));
    }

    function test_get_all_employees() public {
        uint256 testBudge = 1 * 10e18;
        uint256 testLocktime = 100;

        vm.startPrank(controller);
        bank.createEmployee(address(0x1), testBudge, testLocktime);
        bank.createEmployee(address(0x2), testBudge * 2, testLocktime);
        bank.createEmployee(address(0x3), testBudge * 9, testLocktime);
        bank.createEmployee(address(0x4), testBudge * 9, testLocktime);
        bank.createEmployee(address(0x5), testBudge * 9, testLocktime);
        vm.stopPrank();

        assertEq(bank.getAllEmployees().length, 5);
    }
}
