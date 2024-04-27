// npx hardhat test test/scrolly.test.js

const { expect } = require("chai");

describe("Scrolly Badge test", function () {
  let scrollyBadgeContract;

  let user1 = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";
  let user2 = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8";
  let user3 = "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC";
  let user4 = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045";
  let fakeResolver = "0x90F79bf6EB2c4f870365E785982E1f101E93b906";

  beforeEach(async function () {

    const MockActivityPoints = await ethers.getContractFactory("MockActivityPoints");
    const mockActivityPointsContract = await MockActivityPoints.deploy();
    await mockActivityPointsContract.deployed();

    const ScrollBadgeLevelsScrolly = await ethers.getContractFactory("ScrollBadgeLevelsScrolly");
    scrollyBadgeContract = await ScrollBadgeLevelsScrolly.deploy(
      fakeResolver,
      mockActivityPointsContract.address,
      "https...", // default badge URI
      "https..." // base badge URI
    );
    await scrollyBadgeContract.deployed();

  });

  it("checks if user 1 is eligible and level", async function () {
    // get points of user1
    const points = await scrollyBadgeContract.getPoints(user1);
    console.log("User 1 points in wei:", points.toString());
    console.log("User 1 points in ether:", ethers.utils.formatEther(points));

    const isEligible = await scrollyBadgeContract.isEligible(user1);
    console.log("Is User 1 eligible?", isEligible);
    expect(isEligible).to.equal(true);

    const level = await scrollyBadgeContract.getLevel(user1);
    console.log("User 1 level:", level.toString());
  });

  it("checks if user 2 is eligible and level", async function () {
    // get points of user2
    const points = await scrollyBadgeContract.getPoints(user2);
    console.log("User 2 points in wei:", points.toString());
    console.log("User 2 points in ether:", ethers.utils.formatEther(points));

    const isEligible = await scrollyBadgeContract.isEligible(user2);
    console.log("Is User 2 eligible?", isEligible);
    expect(isEligible).to.equal(true);

    const level = await scrollyBadgeContract.getLevel(user2);
    console.log("User 2 level:", level.toString());
  });

  it("checks if user 3 is eligible and level", async function () {
    // get points of user3
    const points = await scrollyBadgeContract.getPoints(user3);
    console.log("User 3 points in wei:", points.toString());
    console.log("User 3 points in ether:", ethers.utils.formatEther(points));

    const isEligible = await scrollyBadgeContract.isEligible(user3);
    console.log("Is User 3 eligible?", isEligible);
    expect(isEligible).to.equal(true);

    const level = await scrollyBadgeContract.getLevel(user3);
    console.log("User 3 level:", level.toString());
  });

  it("checks if user 4 is eligible and level", async function () {
    // get points of user4
    const points = await scrollyBadgeContract.getPoints(user4);
    console.log("User 4 points in wei:", points.toString());
    console.log("User 4 points in ether:", ethers.utils.formatEther(points));

    const isEligible = await scrollyBadgeContract.isEligible(user4);
    console.log("Is User 4 eligible?", isEligible);
    expect(isEligible).to.equal(false);

    const level = await scrollyBadgeContract.getLevel(user4);
    console.log("User 4 level:", level.toString());
  });

});