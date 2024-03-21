// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/gateway/XRPLAxelarGateway.sol";

contract DeployXRPLAxelarGateway is Script {
    function run() public {
        address gatewayAddress = vm.envAddress("AXELAR_GATEWAY_ADDRESS");
        address governanceAddress = vm.envAddress("GOVERNANCE_ADDRESS");
        bytes32 salt = vm.envBytes32("SALT");

        if (gatewayAddress == address(0)) {
            revert("GATEWAY_ADDRESS must be set.");
        }

        if (governanceAddress == address(0)) {
            revert("GOVERNANCE_ADDRESS must be set.");
        }

        vm.startBroadcast();

        XRPLAxelarGateway xrplAxelarGateway = new XRPLAxelarGateway{ salt: salt }();
        console.log("XRPLAxelarGateway deployed to:", address(xrplAxelarGateway));

        xrplAxelarGateway.init(gatewayAddress, governanceAddress);

        xrplAxelarGateway.deployToken(
            "Wrapped Ether",
            "WETH",
            18,
            1e50,
            0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9,
            1e50
        );

        xrplAxelarGateway.deployToken(
            "Axelar Wrapped XRP",
            "axlXRP",
            6,
            1e50,
            address(0),
            1e50
        );

        vm.stopBroadcast();
    }
}
