// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import {Bank} from "../src/bank/Bank.sol";
import {ERC20} from "../src/ERC20.sol";

contract Local is Script {
    Bank bank;
    ERC20 token;
    address bob = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
    address alice = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    address eve = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;
    address trent = 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65;

    function run() public {
        vm.startBroadcast(
            0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
        );

        token = new ERC20("Token", "TKN", 18);
        bank = new Bank(address(token));

        bank.createEmployee(bob, 100*10e18, 40);
        bank.createEmployee(alice, 100*10e18, 40);
        bank.createEmployee(eve, 100*10e18, 800);
        bank.createEmployee(trent, 100*10e18, 10);

        vm.stopBroadcast();
    }

    function test_bank() public {}
}
