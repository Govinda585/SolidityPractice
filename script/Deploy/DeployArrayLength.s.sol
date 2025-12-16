// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
import {Script} from "forge-std/Script.sol";
import {ArrayLength} from "../../src/ArrayLength.sol";
contract DeployArrayLength is Script {
    function run() public {
        vm.startBroadcast();
        ArrayLength arrayLength = new ArrayLength();

        vm.stopBroadcast();
    }
}
