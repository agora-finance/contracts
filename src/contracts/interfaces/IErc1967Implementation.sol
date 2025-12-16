// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.4;

interface IErc1967Implementation {
    function implementationAddress() external view returns (address);
    function proxyAdminAddress() external view returns (address);
}
