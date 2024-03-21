// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IXRPLAxelarGateway } from '../interfaces/IXRPLAxelarGateway.sol';
import { IAxelarGateway } from '../interfaces/IAxelarGateway.sol';

contract XRPLAxelarGateway is IXRPLAxelarGateway {
    IAxelarGateway public gateway;
    address public governance;

    modifier onlyGovernance() {
        if (msg.sender != governance) revert NotGovernance();
        _;
    }

    function init(address gateway_, address governance_) external {
        if (address(gateway) != address(0) || governance != address(0)) revert ContractAlreadyInitialized();
        //if (gateway_.code.length == 0) revert InvalidGateway();

        gateway = IAxelarGateway(gateway_);
        governance = governance_;
    }

   /**
    * @notice Called on the destination chain gateway by the recipient of the cross-chain contract call to validate it and only allow execution
    * if this function returns true.
    * @dev Once validated, the gateway marks the message as executed so the contract call is not executed twice.
    * @param commandId The gateway command ID
    * @param sourceChain The source chain of the contract call
    * @param sourceAddress The source address of the contract call
    * @param payload The payload for that will be sent with the call
    * @return valid True if the contract call is approved, false otherwise
    */
    function validateContractCall(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) external override returns (bool valid) {
        return gateway.validateContractCallFromXRPL(
            commandId,
            sourceChain,
            sourceAddress,
            payload,
            msg.sender
        );
    }

    /**
     * @notice Send the specified token to the destination chain and address.
     * @param destinationChain The chain to send tokens to. A registered chain name on Axelar must be used here
     * @param destinationAddress The address on the destination chain to send tokens to
     * @param symbol The symbol of the token to send
     * @param amount The amount of tokens to send
     */
    function sendToken(
        string calldata destinationChain,
        string calldata destinationAddress,
        string calldata symbol,
        uint256 amount
    ) external {
        gateway.burnTokenFrom(msg.sender, symbol, amount);
        bytes memory payload = abi.encode(symbol, amount);
        gateway.callContract(
            destinationChain,
            destinationAddress,
            payload
        );
    }

    /**
     * @notice Checks whether a contract call has been approved by the gateway.
     * @param commandId The gateway command ID
     * @param sourceChain The source chain of the contract call
     * @param sourceAddress The source address of the contract call
     * @param contractAddress The contract address that will be called
     * @param payloadHash The hash of the payload for that will be sent with the call
     * @return bool A boolean value indicating whether the contract call has been approved by the gateway.
     */
    function isContractCallApproved(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        address contractAddress,
        bytes32 payloadHash
    ) external view override returns (bool) {
        return gateway.isContractCallApproved(
            commandId,
            sourceChain,
            sourceAddress,
            contractAddress,
            payloadHash
        );
    }

   /**
    * @notice Deploys a new token or registers an existing token in the gateway contract itself.
    * @dev If the token address is not specified, a new token is deployed and registed as InternalBurnableFrom
    * @dev If the token address is specified, the token is marked as External.
    * @dev Emits a TokenDeployed event with the symbol and token address.
    */
    function deployToken(
        string calldata name,
        string calldata symbol,
        uint8 decimals,
        uint256 cap,
        address tokenAddress,
        uint256 mintLimit
    ) external onlyGovernance {
        bytes memory params = abi.encode(name, symbol, decimals, cap, tokenAddress, mintLimit);
        gateway.deployToken(params, bytes32(0));
    }

    function setAxelarGateway(address gateway_) external onlyGovernance {
        gateway = IAxelarGateway(gateway_);
    }

   /**
    * @notice Checks whether a command with a given command ID has been executed.
    * @param commandId The command ID to check
    * @return bool True if the command has been executed, false otherwise
    */
    function isCommandExecuted(bytes32 commandId) external view override returns (bool) {
        return gateway.isCommandExecuted(commandId);
    }

   /**
    * @notice Executes a batch of commands signed by the Axelar network. There are a finite set of command types that can be executed.
    * @param input The encoded input containing the data for the batch of commands, as well as the proof that verifies the integrity of the data.
    * @dev Each command has a corresponding commandID that is guaranteed to be unique from the Axelar network.
    * @dev This function allows retrying a commandID if the command initially failed to be processed.
    * @dev Ignores unknown commands or duplicate commandIDs.
    * @dev Emits an Executed event for successfully executed commands.
    */
    // slither-disable-next-line cyclomatic-complexity
    function execute(bytes calldata input) external override {
        gateway.execute(input);
    }
}
