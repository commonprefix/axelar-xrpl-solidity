// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/executable/examples/ExecutableSample.sol";

contract DeployExecutableSample is Script {
    function run() public {
        address gatewayAddress = vm.envAddress("XRPL_AXELAR_GATEWAY_ADDRESS");

        if (gatewayAddress == address(0)) {
            revert("XRPL_AXELAR_GATEWAY_ADDRESS must be set.");
        }

        vm.startBroadcast();

        ExecutableSample executableSample = new ExecutableSample(gatewayAddress);
        console.log("ExecutableSample deployed to:", address(executableSample));

        vm.stopBroadcast();
    }
}
