// SPDX-License-Identifier: ISC
pragma solidity ^0.8.28;

import { AgoraAccessControl } from "./AgoraAccessControl.sol";

contract AgoraAccessControlWithExecutor is AgoraAccessControl {
    constructor(address _initialAdminAddress) {
        _initializeAgoraAccessControl({ _initialAdminAddress: _initialAdminAddress });
    }

    function execute(address _target, bytes memory _data, uint256 _value) external payable {
        _execute({ _target: _target, _data: _data, _value: _value });
    }

    function execute(address _target, bytes memory _data) external payable {
        _execute({ _target: _target, _data: _data, _value: msg.value });
    }

    function _execute(address _target, bytes memory _data, uint256 _value) internal {
        _requireSenderIsRole({ _role: ACCESS_CONTROL_MANAGER_ROLE });
        (bool success, ) = _target.call{ value: _value }(_data);
        if (!success) revert ExecuteCallFailed();
    }

    error ExecuteCallFailed();
}
