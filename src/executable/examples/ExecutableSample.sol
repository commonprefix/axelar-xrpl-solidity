// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { XRPLAxelarExecutable } from '../XRPLAxelarExecutable.sol';
import { IXRPLAxelarGateway } from '../../interfaces/IXRPLAxelarGateway.sol';

contract ExecutableSample is XRPLAxelarExecutable {
    string public message;
    string public sourceChain;
    string public sourceAddress;
    string public tokenSymbol;
    uint256 public tokenAmount;

    constructor(address gateway_) XRPLAxelarExecutable(gateway_) {
    }

    function _execute(
        string calldata sourceChain_,
        string calldata sourceAddress_,
        bytes calldata payload_
    ) internal override {
        bytes memory contractPayload;
        (tokenSymbol, tokenAmount, contractPayload) = abi.decode(payload_, (string, uint256, bytes));
        (message) = abi.decode(contractPayload, (string));
        sourceChain = sourceChain_;
        sourceAddress = sourceAddress_;
    }
}
