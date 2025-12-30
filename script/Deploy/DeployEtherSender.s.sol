// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {EtherSender} from "../../src/EtherSender.sol";
contract DeployEtherSender is Script {
    function run() public {
        vm.startBroadcast();
        EtherSender etherSender = new EtherSender();
        console.log("Deployed EtherSender at:", address(etherSender));

        vm.stopBroadcast();
    }
}
