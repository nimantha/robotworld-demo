const RobotFactory = artifacts.require("RobotFactory");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("RobotFactory", function (accounts) {
  it("should assert true", async function () {
    await RobotFactory.deployed();
    return assert.isTrue(true);
  });

  describe("getRobotCount()", () => {
    it("should return '10'", async () => {
      const robotFactory = await RobotFactory.deployed();
      const result = await robotFactory.getRobotCount();
      assert.equal(result, 10);
    });
  });

  describe("owner()", () => {
    it("should return the owner", async () => {
      const robotFactory = await RobotFactory.deployed();
      const result = await robotFactory.owner();
      assert(result, "the current owner");
    });
  });

});
