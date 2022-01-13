const { ethers } = require("hardhat");

describe("SuoerSeaTemplate", function () {
  it("Should subscribe twice and mint 1 NFT", async function () {
    const Contract = await ethers.getContractFactory("SuperSea");

    const contract = await Contract.deploy();
    await contract.deployed();

    // Subscribe 30 Days
    let subscribe30DaysTxn = await contract.subscribe(0, {
      value: hre.ethers.utils.parseEther("0.1"),
    });
    await subscribe30DaysTxn.wait();

    // Subscribe 365 Days
    let subscribe365DaysTxn = await contract.subscribe(1, {
      value: hre.ethers.utils.parseEther("0.5"),
    });
    await subscribe365DaysTxn.wait();

    // Call the function.
    let mintTxn = await contract.mint({
      value: hre.ethers.utils.parseEther("0.75"),
    });
    // Wait for it to be mined.
    await mintTxn.wait();
  });
});
