// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 defaultValue;
        bool isLocal;
    }

    NetworkConfig private activeConfig;
    function getActiveConfig() public returns (NetworkConfig memory) {
        if (block.chainid == 11155111) {
            // Sepolia
            return NetworkConfig({defaultValue: 777, isLocal: false});
        }
        if (block.chainid == 80002) {
            // Polygon Amoy
            return NetworkConfig({defaultValue: 888, isLocal: false});
        }

        return getOrCreateAnvilConfig();
    }
    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (activeConfig.isLocal) {
            return activeConfig;
        }
        activeConfig = NetworkConfig({defaultValue: 123, isLocal: true});

        return activeConfig;
    }
}
