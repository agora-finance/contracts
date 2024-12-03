// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.0;

// ====================================================================
//             _        ______     ___   _______          _
//            / \     .' ___  |  .'   `.|_   __ \        / \
//           / _ \   / .'   \_| /  .-.  \ | |__) |      / _ \
//          / ___ \  | |   ____ | |   | | |  __ /      / ___ \
//        _/ /   \ \_\ `.___]  |\  `-'  /_| |  \ \_  _/ /   \ \_
//       |____| |____|`._____.'  `.___.'|____| |___||____| |____|
// ====================================================================
// ======================== AgoraProxyAdmin ===========================
// ====================================================================

import { Ownable, Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { ITransparentUpgradeableProxy } from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

/// @title AgoraProxyAdmin
/// @notice A proxy admin contract that extends the OpenZeppelin ProxyAdmin contract and adds a two-step ownership transfer mechanism
/// @author Agora
contract AgoraProxyAdmin is Ownable2Step {
    /// @notice Initializes the contract with the initial owner
    /// @param _initialOwner The address that will be set as the initial owner of the contract
    constructor(address _initialOwner) Ownable(_initialOwner) {}

    function upgradeAndCall(
        ITransparentUpgradeableProxy proxy,
        address implementation,
        bytes memory data
    ) public payable virtual onlyOwner {
        proxy.upgradeToAndCall{ value: msg.value }(implementation, data);
    }
}
