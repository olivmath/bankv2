// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {BaseSetup} from "../BaseSetup.sol";
import {Bank} from "../../src/bank/Bank.sol";
import {ERC20} from "../../src/ERC20.sol";

contract BankSetup is BaseSetup {
    Bank bank;
    ERC20 token;

    function setUp() public virtual override {
        BaseSetup.setUp();

        vm.startPrank(controller);
        token = new ERC20("Token", "TKN", 18);
        bank = new Bank(address(token));
        vm.stopPrank();
    }

    function test_bank() public {}
}
