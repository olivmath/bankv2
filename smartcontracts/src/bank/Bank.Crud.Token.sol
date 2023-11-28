// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Employee} from "../../src/bank/Bank.Types.sol";
import {EmployeeCrud} from "./Bank.Crud.Employee.sol";
import {ERC20} from "../ERC20.sol";

contract TokenCrud is EmployeeCrud {
    constructor(address _token) EmployeeCrud(_token) {}

    function getBalance() external view returns (uint256 balance) {
        balance = token.balanceOf(address(this));
    }

    function getTotalEmployeeCost() external view returns (uint256 totalCost) {
        for (uint256 i = 0; i < employeeList.length; i++) {
            address employeeAddress = employeeList[i];
            Employee memory emp = employees[employeeAddress];
            totalCost += emp.salary + emp.bonus;
        }
    }

    function getToken() external view returns (address) {
        return address(token);
    }

    function setToken(address _token) external {
        onlyController();
        token = ERC20(_token);

        emit NewToken(_token);
    }
}
