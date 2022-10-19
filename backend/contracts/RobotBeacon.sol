// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract RobotBeacon {

    UpgradeableBeacon immutable beacon;
    
    address private implAddress;

    constructor(address _implAddress) {
        beacon = new UpgradeableBeacon(_implAddress);
        implAddress = _implAddress;
    }

    function update(address _implAddress) public {
        beacon.upgradeTo(_implAddress);
        implAddress = _implAddress;
    }

    function implementation() public view returns(address) {
        return beacon.implementation();
    }

}