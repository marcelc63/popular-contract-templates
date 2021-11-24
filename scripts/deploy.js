const main = async () => {
  const ContractFactory = await hre.ethers.getContractFactory("ChainRunners");

  const contract = await ContractFactory.deploy();
  await contract.deployed();
  console.log("Contract deployed to:", contract.address);

  const RendererContractFactory = await hre.ethers.getContractFactory(
    "ChainRunnersBaseRenderer"
  );

  const rendererContract = await RendererContractFactory.deploy();
  await rendererContract.deployed();
  console.log("Contract deployed to:", rendererContract.address);

  // NOTE: Will update with code on setting renderer contract and bytecodes
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
