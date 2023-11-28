// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {TokenCrud} from "./Bank.Crud.Token.sol";
import {Employee} from "./Bank.Types.sol";

import {console2} from "forge-std/console2.sol";

contract Bank is TokenCrud {
    constructor(address _token) TokenCrud(_token) {}

    function payAllEmployees() external returns (bool) {
        onlyController();
        Employee storage emp;
        uint256 contractBalance = token.balanceOf(address(this));

        for (uint256 i = 0; i < employeeList.length; i++) {
            address employee = employeeList[i];
            emp = employees[employee];
            uint256 total = emp.salary + emp.bonus;

            if (emp.locktime > block.number) {
                continue;
            }

            if (contractBalance >= total) {
                emp.nextPayment = block.number + emp.locktime;
                emp.bonus = 0;
                contractBalance -= total;

                token.transfer(emp.employee, total);

                emit Paid(emp.employee, total, block.number + emp.locktime);
            } else {
                if (contractBalance > 0) {
                    token.transfer(emp.employee, contractBalance);
                    emp.bonus = total - contractBalance;
                    contractBalance = 0;
                } else {
                    emp.bonus += emp.salary;
                }

                if (i != 0) {
                    address temp = employeeList[0];
                    employeeList[0] = employeeList[i];
                    employeeList[i] = temp;
                }

                emit Bonus(emp.employee, emp.bonus);
            }
        }

        return true;
    }
}
