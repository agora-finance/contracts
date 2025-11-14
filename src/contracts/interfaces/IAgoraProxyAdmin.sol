// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.4;

library AgoraProxyAdmin {
    struct Version {
        uint256 major;
        uint256 minor;
        uint256 patch;
    }
}

interface IAgoraProxyAdmin {
    error AddressIsNotRole(string role);
    error CannotRemoveRoleWithMembers(string role);
    error CannotRevokeSelf();
    error RoleDoesNotExist(string role);
    error RoleNameTooLong();

    event RoleAssigned(string indexed role, address indexed member);
    event RoleRevoked(string indexed role, address indexed member);

    function ACCESS_CONTROL_MANAGER_ROLE() external view returns (string memory);
    function AGORA_ACCESS_CONTROL_STORAGE_SLOT() external view returns (bytes32);
    function getAccessControlManagerRoleMembers() external view returns (address[] memory);
    function getAllRoles() external view returns (string[] memory _roles);
    function getRoleMembers(string memory _role) external view returns (address[] memory);
    function grantAccessControlManagerRole(address _member) external;
    function hasRole(string memory _role, address _member) external view returns (bool);
    function revokeAccessControlManagerRole(address _member) external;
    function upgradeAndCall(address _proxy, address _implementation, bytes memory _calldata) external payable;
    function version() external pure returns (AgoraProxyAdmin.Version memory _version);
}
