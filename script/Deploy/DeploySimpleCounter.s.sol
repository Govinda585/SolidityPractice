// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {SimpleCounter} from "../../src/SimpleCounter.sol";
import {HelperConfig} from "../Helper/HelperConfig.s.sol";
contract DeploySimpleCounter is Script {
    function run() external returns (SimpleCounter) {
        HelperConfig helper = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helper.getActiveConfig();

        vm.startBroadcast();
        SimpleCounter counter = new SimpleCounter();
        // initialize with network-specific default value
        if (config.defaultValue > 0) {
            counter.increaseBy(config.defaultValue);
        }
        vm.stopBroadcast();

        return counter;
    }
}
