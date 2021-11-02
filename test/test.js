const { ethers } = require("hardhat");

describe("LootTemplate", function () {
  it("Should mint 1 NFT", async function () {
    const Contract = await ethers.getContractFactory("Template");

    const contract = await Contract.deploy();
    await contract.deployed();
  });
});
