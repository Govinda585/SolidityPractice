// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {EtherVault} from "../../src/EtherVault.sol";

contract DeployEtherVault is Script {
    function run() external returns (EtherVault etherVault) {
        uint256 chainId = block.chainid;
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        if (chainId == 11155111) {
            console.log("Deploying to Sepolia");
        } else {
            console.log("Deploying to Local Anvil");
        }

        vm.startBroadcast(deployerKey);
        etherVault = new EtherVault();
        vm.stopBroadcast();

        console.log("EtherVault deployed at:", address(etherVault));
    }
}
