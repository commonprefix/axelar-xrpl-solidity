// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IXRPLAxelarGateway } from './IXRPLAxelarGateway.sol';

interface IXRPLAxelarExecutable {
    error InvalidAddress();
    error NotApprovedByGateway();

    function gateway() external view returns (IXRPLAxelarGateway);

    function execute(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) external;
}
