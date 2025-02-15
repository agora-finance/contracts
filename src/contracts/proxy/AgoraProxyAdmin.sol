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

import { ITransparentUpgradeableProxy } from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import { AgoraAccessControl } from "../access-control/AgoraAccessControl.sol";
/// @title AgoraProxyAdmin
/// @notice A proxy admin contract that allows for multiple admins to be set for better business continuity
/// @author Agora

contract AgoraProxyAdmin is AgoraAccessControl {
    /// @notice Initializes the contract with the initial owner
    /// @param _initialAccessControlAdminAddress The address that will be set as the initial admin of the contract
    constructor(address _initialAccessControlAdminAddress) {
        _initializeAgoraAccessControl({ _initialAdminAddress: _initialAccessControlAdminAddress });
    }

    /// @notice Upgrades the proxy to a new implementation and calls the target with the provided calldata
    /// @param _proxy The proxy to upgrade
    /// @param _implementation The new implementation address
    /// @param _calldata The data to call on the new implementation
    function upgradeAndCall(
        ITransparentUpgradeableProxy _proxy,
        address _implementation,
        bytes memory _calldata
    ) public payable virtual {
        _requireSenderIsRole({ _role: ACCESS_CONTROL_ADMIN_ROLE });
        _proxy.upgradeToAndCall{ value: msg.value }(_implementation, _calldata);
    }

    struct Version {
        uint256 major;
        uint256 minor;
        uint256 patch;
    }

    function version() public pure returns (Version memory _version) {
        return Version({ major: 1, minor: 0, patch: 0 });
    }
}
