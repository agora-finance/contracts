// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.0;

// ====================================================================
//             _        ______     ___   _______          _
//            / \     .' ___  |  .'   `.|_   __ \        / \
//           / _ \   / .'   \_| /  .-.  \ | |__) |      / _ \
//          / ___ \  | |   ____ | |   | | |  __ /      / ___ \
//        _/ /   \ \_\ `.___]  |\  `-'  /_| |  \ \_  _/ /   \ \_
//       |____| |____|`._____.'  `.___.'|____| |___||____| |____|
// ====================================================================
// ======================== AgoraAccessControl ========================
// ====================================================================

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/// @title AgoraAccessControl
/// @notice An abstract contract which contains role-ba
abstract contract AgoraAccessControl {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    string public constant ADMIN_ROLE = "ADMIN_ROLE";

    /// @notice The AgoraAccessControlStorage struct
    /// @param roleData A mapping of role identifier to AgoraAccessControlRoleData to store role data
    /// @custom:storage-location erc7201:AgoraAccessControl.AgoraAccessControlStorage
    struct AgoraAccessControlStorage {
        EnumerableSet.Bytes32Set roles;
        mapping(string _role => EnumerableSet.AddressSet membership) roleMembership;
    }

    //==============================================================================
    // Initialization Functions
    //==============================================================================

    function _initializeAgoraAccessControl(address _initialAdminAddress) internal {
        _addRoleToSet({ _role: ADMIN_ROLE });
        _setRoleMembership({ _role: ADMIN_ROLE, _address: _initialAdminAddress, _insert: true });
        emit RoleAssigned({ role: ADMIN_ROLE, address_: _initialAdminAddress });
    }

    // ============================================================================================
    // Procedural Functions
    // ============================================================================================

    /// @notice The ```assignRole``` function assigns the designated role to an address
    /// @dev Must be called by the Admin
    /// @param _newAddress The address to be assigned the role
    function assignRole(string memory _role, address _newAddress, bool _addRole) external virtual {
        // Checks: Only Admin can transfer role
        _requireIsRole({ _role: ADMIN_ROLE, _address: msg.sender });

        _assignRole({ _role: _role, _newAddress: _newAddress, _addRole: _addRole });
    }

    function _assignRole(string memory _role, address _newAddress, bool _addRole) internal {
        // Effects: Add role to set, no-op if role already exists
        _addRoleToSet({ _role: _role });

        // Effects: Set the roleMembership to the new address
        _setRoleMembership({ _role: _role, _address: _newAddress, _insert: _addRole });

        // Emit event
        if (_addRole) emit RoleAssigned({ role: _role, address_: _newAddress });
        else emit RoleRevoked({ role: _role, address_: _newAddress });
    }

    // ============================================================================================
    // Internal Effects Functions
    // ============================================================================================

    function _addRoleToSet(string memory _role) internal {
        // Checks: Role name must be shorter than 32 bytes
        if (bytes(_role).length > 32) revert RoleNameTooLong();
        _getPointerToAgoraAccessControlStorage().roles.add(bytes32(bytes(_role)));
    }

    function _removeRoleFromSet(string memory _role) internal {
        _getPointerToAgoraAccessControlStorage().roles.remove(bytes32(bytes(_role)));
    }

    /// @notice The ```_setRole``` function sets the role address
    /// @dev This function is to be implemented by a public function
    /// @param _role The role identifier to transfer
    /// @param _address The address of the new role
    /// @param _insert Whether to add or remove the address from the role
    function _setRoleMembership(string memory _role, address _address, bool _insert) internal {
        if (_insert) _getPointerToAgoraAccessControlStorage().roleMembership[_role].add(_address);
        else _getPointerToAgoraAccessControlStorage().roleMembership[_role].remove(_address);
    }

    // ============================================================================================
    // Internal Checks Functions
    // ============================================================================================

    /// @notice The ```_isRole``` function checks if _address is current role address
    /// @param _role The role identifier to check
    /// @param _address The address to check against the role
    /// @return Whether or not msg.sender is current role address
    function _isRole(string memory _role, address _address) internal view returns (bool) {
        return _getPointerToAgoraAccessControlStorage().roleMembership[_role].contains(_address);
    }

    /// @notice The ```_requireIsRole``` function reverts if _address is not current role address
    /// @param _role The role identifier to check
    /// @param _address The address to check against the role
    function _requireIsRole(string memory _role, address _address) internal view {
        if (!_isRole({ _role: _role, _address: _address })) revert AddressIsNotRole({ role: _role });
    }

    /// @notice The ```_requireSenderIsRole``` function reverts if msg.sender is not current role address
    /// @dev This function is to be implemented by a public function
    /// @param _role The role identifier to check
    function _requireSenderIsRole(string memory _role) internal view {
        _requireIsRole({ _role: _role, _address: msg.sender });
    }

    //==============================================================================
    // External View Functions
    //==============================================================================

    /// @notice The ```hasRole``` function checks if _address has the role
    /// @param _role The role identifier to check
    /// @param _address The address to check against the role
    /// @return Whether or not _address has the role
    function hasRole(string memory _role, address _address) external view returns (bool) {
        return _isRole({ _role: _role, _address: _address });
    }

    /// @notice The ```getRoleMembers``` function returns the members of the role
    /// @param _role The role identifier to check
    /// @return _members The members of the role
    function getRoleMembers(string memory _role) external view returns (address[] memory _members) {
        EnumerableSet.AddressSet storage _roleMembership = _getPointerToAgoraAccessControlStorage().roleMembership[
            _role
        ];
        _members = _roleMembership.values();
    }

    /// @notice The ```getAllRoles``` function returns all roles
    /// @return _roles The roles
    function getAllRoles() external view returns (string[] memory _roles) {
        uint256 _length = _getPointerToAgoraAccessControlStorage().roles.length();
        _roles = new string[](_length);
        for (uint256 i = 0; i < _length; i++) {
            _roles[i] = string(abi.encodePacked(_getPointerToAgoraAccessControlStorage().roles.at(i)));
        }
    }

    //==============================================================================
    // Erc 7201: UnstructuredNamespace Storage Functions
    //==============================================================================

    /// @notice The ```AGORA_ACCESS_CONTROL_STORAGE_SLOT``` is the storage slot for the AgoraAccessControlStorage struct
    /// @dev keccak256(abi.encode(uint256(keccak256("AgoraAccessControlStorage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 public constant AGORA_ACCESS_CONTROL_STORAGE_SLOT =
        0x8f8de9240b3899c03a31968f466af060ab1c78464aa7ae14941c20fe7917b000;

    /// @notice The ```_getPointerToAgoraAccessControlStorage``` function returns a pointer to the AgoraAccessControlStorage struct
    /// @return $ A pointer to the AgoraAccessControlStorage struct
    function _getPointerToAgoraAccessControlStorage() internal pure returns (AgoraAccessControlStorage storage $) {
        /// @solidity memory-safe-assembly
        assembly {
            $.slot := AGORA_ACCESS_CONTROL_STORAGE_SLOT
        }
    }

    // ============================================================================================
    // Events
    // ============================================================================================

    /// @notice The ```RoleAssigned``` event is emitted when the role is assigned
    /// @param role The string identifier of the role that was transferred
    /// @param address_ The address of the new role
    event RoleAssigned(string indexed role, address indexed address_);

    /// @notice The ```RoleRevoked``` event is emitted when the role is revoked
    /// @param role The string identifier of the role that was transferred
    event RoleRevoked(string indexed role, address indexed address_);

    // ============================================================================================
    // Errors
    // ============================================================================================

    /// @notice Emitted when role is transferred
    /// @param role The role identifier
    error AddressIsNotRole(string role);

    /// @notice Emitted when role name is too long
    error RoleNameTooLong();
}
