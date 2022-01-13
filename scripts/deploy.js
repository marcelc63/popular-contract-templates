const main = async () => {
  const ContractFactory = await hre.ethers.getContractFactory("LootTemplate");

  const contract = await ContractFactory.deploy();
  await contract.deployed();
  console.log("Contract deployed to:", contract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
