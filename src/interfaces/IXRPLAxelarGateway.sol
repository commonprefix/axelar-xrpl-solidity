// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IXRPLAxelarGateway {
    /**********\
    |* Errors *|
    \**********/

    error InvalidGateway();
    error NotGovernance();
    error ContractAlreadyInitialized();

    /********************\
    |* Public Functions *|
    \********************/

    function sendToken(
        string calldata destinationChain,
        string calldata destinationAddress,
        string calldata symbol,
        uint256 amount
    ) external;

    function execute(bytes calldata input) external;

    function validateContractCall(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) external returns (bool);

    /***********\
    |* Getters *|
    \***********/

    function isCommandExecuted(bytes32 commandId) external view returns (bool);

    function isContractCallApproved(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        address contractAddress,
        bytes32 payloadHash
    ) external view returns (bool);

    /*******************\
    |* Admin Functions *|
    \*******************/

    function deployToken(
        string calldata name,
        string calldata symbol,
        uint8 decimals,
        uint256 cap,
        address tokenAddress,
        uint256 mintLimit
    ) external;
}
