// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Auth} from "./Bank.Auth.sol";
import {Employee} from "./Bank.Types.sol";

contract EmployeeCrud is Auth {
    constructor(address _token) Auth(_token) {}

    function createEmployee(address _employee, uint256 _salary, uint256 _locktime) external {
        onlyController();
        checkZeroAddress(_employee);
        checkSalary(_salary);
        employeeMustNotExist(_employee);

        uint256 initialBonus = 0;
        employees[_employee] = Employee(_employee, _salary, _locktime, block.number + _locktime, initialBonus);
        employeeList.push(_employee);

        emit NewEmployee(_employee);
    }

    function updateEmployee(address _employee, uint256 _salary, uint256 _locktime) external {
        onlyController();
        checkZeroAddress(_employee);
        checkSalary(_salary);
        employeeMustExist(_employee);

        employees[_employee].salary = _salary;
        employees[_employee].locktime = _locktime;

        emit UpdateEmployee(_employee);
    }

    function deleteEmployee(address _employee) external {
        onlyController();
        checkZeroAddress(_employee);
        employeeMustExist(_employee);

        employees[_employee] = Employee(address(0x0), 0, 0, 0, 0);

        for (uint256 i = 0; i < employeeList.length; i++) {
            if (employeeList[i] == _employee) {
                employeeList[i] = employeeList[employeeList.length - 1];
                employeeList.pop();
                break;
            }
        }

        emit DeleteEmployee(_employee);
    }

    function getEmployee(address _employee) external view returns (Employee memory emp) {
        emp = employees[_employee];
    }

    function getAllEmployees() external view returns (address[] memory) {
        return employeeList;
    }
}
