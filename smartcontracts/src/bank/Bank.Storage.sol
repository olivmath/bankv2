// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "../ERC20.sol";
import {Events} from "./Bank.Events.sol";
import {Employee} from "./Bank.Types.sol";

contract Storage is Events {
    address constant ZERO_ADDRESS = address(0x0);

    address public controller;
    address[] employeeList;
    address[] paymentsDelayed;

    mapping(address => Employee) employees;

    ERC20 public token;

    constructor(address _token) Events() {
        token = ERC20(_token);
        controller = msg.sender;
    }
}
