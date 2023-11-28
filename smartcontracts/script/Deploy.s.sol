// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import "forge-std/Script.sol";
import {Bank} from "../src/bank/Bank.sol";
import {ERC20} from "../src/ERC20.sol";


contract Local is Script {
    Bank bank;
    ERC20 token;

    function run() public {
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

        token = new ERC20("Token", "TKN", 18);
        bank = new Bank(address(token));



        vm.stopBroadcast();
    }

    function test_bank() public {}
}
