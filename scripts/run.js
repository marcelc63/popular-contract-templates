const main = async () => {
  const ContractFactory = await hre.ethers.getContractFactory("LootTemplate");

  const contract = await ContractFactory.deploy();
  await contract.deployed();
  console.log("Contract deployed to:", contract.address);

  // Mint loot bag with token id 1
  let mintTxn = await contract.claim(1);
  await mintTxn.wait();

  // Check the tokenURI
  let tokenURI = await contract.tokenURI(1);
  console.log(tokenURI);
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
