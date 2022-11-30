// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "./Robot.sol";
import "./RobotBeacon.sol";

contract RobotFactory {
  RobotBeacon immutable beacon;
  
  address[] private robotArray;

  constructor(address _implAddress) {
      beacon = new RobotBeacon(_implAddress);
  }

  function createRobot(string memory _master) external returns(address)  {
    require(bytes(_master).length > 0, "Invalid inputs for Robot initialization!");
      BeaconProxy proxy = new BeaconProxy(address(beacon), 
            abi.encodeWithSelector(Robot(address(0)).initialize.selector, _master) 
        );
        robotArray.push(address(proxy));
        return address(proxy);
  }

  function getAllRobots() external view returns(address[] memory) {
    return robotArray;
  }

  function setRobotMaster(uint32 _idx, string memory _master) external {
    Robot(robotArray[_idx]).setMaster(_master);
  }

  function getRobotMaster(uint32 _idx) external view returns(string memory) {
    return Robot(robotArray[_idx]).getMaster();
  }

  function useRobotBrain(uint32 _idx) external view returns(string memory) {
    return Robot(robotArray[_idx]).useBrain();
  }

  function setImplementation(address _implAddress) external {
    beacon.update(_implAddress);
  }

  function getImplementation() external view returns(address) {
    return beacon.implementation();
  }

}
