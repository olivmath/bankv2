// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Errors} from "./Bank.Errors.sol";

contract Events is Errors {
    constructor() Errors() {}

    event Paid(address indexed employee, uint256 salary, uint256 nextPayment);
    event Bonus(address indexed employee, uint256 bonus);
    event UpdateEmployee(address indexed employee);
    event DeleteEmployee(address indexed employee);
    event NewEmployee(address indexed employee);
    event NewDeposit(uint256 indexed value);
    event NewToken(address indexed token);
}
