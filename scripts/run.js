const main = async () => {
  const ContractFactory = await hre.ethers.getContractFactory("SuperSea");

  const contract = await ContractFactory.deploy();
  await contract.deployed();
  console.log("Contract deployed to:", contract.address);

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
