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
// ====================== Erc1967Implementation =======================
// ====================================================================

/// @title Erc1967Implementation
/// @notice The Erc1967Implementation is a contract that provides visibility into the Erc1967Implementation and its associated storage slots.
/// @author Agora
abstract contract Erc1967Implementation {
    //==============================================================================
    // Erc1967 Admin Slot Items
    //==============================================================================

    /// @notice The Erc1967ProxyAdminStorage struct
    /// @param proxyAdminAddress The address of the proxy admin contract
    /// @custom:storage-location erc1967:eip1967.proxy.admin
    struct Erc1967ProxyAdminStorage {
        address proxyAdminAddress;
    }

    /// @notice The ```ERC1967_PROXY_ADMIN_STORAGE_SLOT_``` is the storage slot for the Erc1967ProxyAdminStorage struct
    /// @dev NOTE: deviates from erc7201 standard because erc1967 defines its own storage slot algorithm
    /// @dev bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1)
    bytes32 internal constant ERC1967_PROXY_ADMIN_STORAGE_SLOT_ =
        0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /// @notice The ```getPointerToErc1967ProxyAdminStorage``` function returns a pointer to the Erc1967ProxyAdminStorage struct
    /// @return adminSlot A pointer to the Erc1967ProxyAdminStorage struct
    function getPointerToErc1967ProxyAdminStorage() internal pure returns (Erc1967ProxyAdminStorage storage adminSlot) {
        /// @solidity memory-safe-assembly
        assembly {
            adminSlot.slot := ERC1967_PROXY_ADMIN_STORAGE_SLOT_
        }
    }

    /// @notice The ```proxyAdminAddress``` function returns the address of the proxy admin
    /// @return The address of the proxy admin
    function proxyAdminAddress() external view returns (address) {
        return getPointerToErc1967ProxyAdminStorage().proxyAdminAddress;
    }

    //==============================================================================
    // EIP1967 Proxy Implementation Slot Items
    //==============================================================================

    /// @notice The Erc1967ProxyContractStorage struct
    /// @param implementationAddress The address of the implementation contract
    /// @custom:storage-location erc1967:eip1967.proxy.implementation
    struct Erc1967ProxyContractStorage {
        address implementationAddress;
    }

    /// @notice The ```ERC1967_IMPLEMENTATION_CONTRACT_STORAGE_SLOT_``` is the storage slot for the implementation contract
    /// @dev bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
    bytes32 internal constant ERC1967_IMPLEMENTATION_CONTRACT_STORAGE_SLOT_ =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /// @notice The ```getPointerToImplementationStorage``` function returns a pointer to the Erc1967ProxyContractStorage struct
    /// @return implementationSlot A pointer to the Erc1967ProxyContractStorage struct
    function getPointerToImplementationStorage()
        internal
        pure
        returns (Erc1967ProxyContractStorage storage implementationSlot)
    {
        /// @solidity memory-safe-assembly
        assembly {
            implementationSlot.slot := ERC1967_IMPLEMENTATION_CONTRACT_STORAGE_SLOT_
        }
    }

    /// @notice The ```implementationAddress``` function returns the address of the implementation contract
    /// @return The address of the implementation contract
    function implementationAddress() external view returns (address) {
        return getPointerToImplementationStorage().implementationAddress;
    }
}
