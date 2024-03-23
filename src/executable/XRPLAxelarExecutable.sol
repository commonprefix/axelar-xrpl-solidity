// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IXRPLAxelarGateway } from '../interfaces/IXRPLAxelarGateway.sol';
import { IXRPLAxelarExecutable } from '../interfaces/IXRPLAxelarExecutable.sol';

contract XRPLAxelarExecutable is IXRPLAxelarExecutable {
    IXRPLAxelarGateway public immutable gateway;

    constructor(address gateway_) {
        if (gateway_ == address(0)) revert InvalidAddress();

        gateway = IXRPLAxelarGateway(gateway_);
    }

    function execute(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) external {
        if (!gateway.validateContractCall(commandId, sourceChain, sourceAddress, payload))
            revert NotApprovedByGateway();

        _execute(sourceChain, sourceAddress, payload);
    }

    function _execute(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) internal virtual {}
}
