// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "./Robot.sol";
import "./RobotBeacon.sol";

contract RobotFactory is Ownable {
  RobotBeacon immutable beacon;
  
  address[] public robotArray;
  uint32 private robotCount = 0;


  constructor(address _implAddress) {
      beacon = new RobotBeacon(_implAddress);
  }


  function createRobot(string memory _name, string memory _master) external onlyOwner returns(address)  {
      BeaconProxy proxy = new BeaconProxy(address(beacon), 
            abi.encodeWithSelector(Robot(address(0)).initialize.selector, _name, _master)
        );
        robotArray.push(address(proxy));
        return address(proxy);
  }

  function getRobotCount() external view returns (uint256) {
    return robotArray.length;
  }

  function getAllRobots() public view returns(address[] memory) {
    return robotArray;
  }

  function setRobotMaster(uint32 _idx, string memory _master) external onlyOwner {
    Robot(robotArray[_idx]).setMaster(_master);
  }

  function getRobotMaster(uint32 _idx) public view returns(string memory) {
    return Robot(robotArray[_idx]).getMaster();
  }

  function useRobotBrain(uint32 _idx) public view returns(string memory) {
    return Robot(robotArray[_idx]).useBrain();
  }

  function setImplementation(address _implAddress) public {
    beacon.update(_implAddress);
  }

  function getImplementation() public view returns(address) {
    return beacon.implementation();
  }

}
