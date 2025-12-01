// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/SimpleStorageName.sol";

contract DeploySimpleStorageName is Script {
    function run() external {
        // start broadcasting transaction to the network
        vm.startBroadcast();

        // Deploy your contract
        SimpleStorageName simpleStorageName = new SimpleStorageName();

        // Stop broadcasting
        vm.stopBroadcast();
    }
}
