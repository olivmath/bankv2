// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Storage} from "./Bank.Storage.sol";

contract Auth is Storage {
    constructor(address _token) Storage(_token) {}

    function onlyController() internal view {
        if (controller != msg.sender) {
            revert Unauthorized();
        }
    }

    function employeeMustExist(address employee) internal view {
        if (employees[employee].employee == address(0)) {
            revert EmployeeNotFound();
        }
    }

    function employeeMustNotExist(address employee) internal view {
        if (employees[employee].employee != address(0)) {
            revert EmployeeAlreadyAdd();
        }
    }

    function checkSalary(uint256 salary) internal pure {
        if (salary < 1 * 10e18) {
            revert SalaryTooLow();
        }
    }

    function checkZeroAddress(address addr) internal pure {
        if (addr == ZERO_ADDRESS) {
            revert ZeroAddress();
        }
    }

    function checkLocktime(uint256 locktime) internal view {
        if (locktime <= block.number) {
            revert LocktimeTooLow();
        }
    }
}
