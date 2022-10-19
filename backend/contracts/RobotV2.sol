// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract RobotV2 is Initializable {
    string public name;
    string private master;

    function initialize(string memory _name, string memory _master) public initializer {
        name = _name;
        master = _master;
    }

    function useBrain() public view returns(string memory) {
        return string(abi.encodePacked("I will do what ever ", master, " asks us but in a new and more efficient way!"));
    }

    function setMaster(string memory _master) public {
        master = _master;
    }

    function getMaster() public view returns(string memory) {
        return master;
    }
}
