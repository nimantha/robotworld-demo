// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract Robot is ERC721Upgradeable {
    string private master;

    function initialize(string memory _master) public initializer {
        master = _master;
        __ERC721_init("Robot", "RBT");
    }

    function useBrain() public view returns(string memory) {
        return string(abi.encodePacked("I will do what ever ", master, " asks of us!"));
    }

    function setMaster(string memory _master) public {
        master = _master;
    }

    function getMaster() public view returns(string memory) {
        return master;
    }
}

