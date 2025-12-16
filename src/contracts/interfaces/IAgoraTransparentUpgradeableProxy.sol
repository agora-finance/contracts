// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.4;

interface IAgoraTransparentUpgradeableProxy {
    struct ConstructorParams {
        address logic;
        address proxyAdminAddress;
        bytes data;
    }

    error AddressEmptyCode(address target);
    error ERC1967InvalidAdmin(address admin);
    error ERC1967InvalidImplementation(address implementation);
    error ERC1967NonPayable();
    error FailedCall();
    error ProxyDeniedAdminAccess();

    event AdminChanged(address previousAdmin, address newAdmin);
    event Upgraded(address indexed implementation);

    fallback() external payable;
}
