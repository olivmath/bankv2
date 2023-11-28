// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Errors {
    constructor() {}

    error Unauthorized();
    error EmployeeAlreadyAdd();
    error EmployeeNotFound();
    error SalaryTooLow();
    error LocktimeTooLow();
    error ZeroAddress();
}
