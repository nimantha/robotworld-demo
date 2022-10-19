const RobotFactory = artifacts.require('RobotFactory');

module.exports = function(deployer) {
    deployer.deploy(RobotFactory, "0x928a7cF73521AD56273c957dfdc772cb90Bb48b5");
}