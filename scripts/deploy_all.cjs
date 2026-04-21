const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // 1. Deploy the Coin (ERC-20)
  const Coin = await hre.ethers.getContractFactory("ERC20Token"); // Use your actual Coin contract name
  const coin = await Coin.deploy("Diamond Gym Coin", "DGC",10000);
  await coin.waitForDeployment();
  const coinAddress = await coin.getAddress();
  console.log("Coin deployed to:", coinAddress);

  // 2. Deploy the NFT (ERC-721)
  const NFT = await hre.ethers.getContractFactory("EngineeringNFT"); 
  const nft = await NFT.deploy();
  await nft.waitForDeployment();
  const nftAddress = await nft.getAddress();
  console.log("NFT deployed to:", nftAddress);

  // 3. Deploy the Vault (Pass in Coin and NFT addresses)
  const Vault = await hre.ethers.getContractFactory("Vault"); 
  const vault = await Vault.deploy(coinAddress, nftAddress);
  await vault.waitForDeployment();
  const vaultAddress = await vault.getAddress();
  console.log("Vault deployed to:", vaultAddress);

  // 4. LINKING: Give Vault ownership of the NFT
  console.log("Linking Vault to NFT...");
  const tx = await nft.transferOwnership(vaultAddress);
  await tx.wait();

  console.log("-----------------------------------------");
  console.log("SUCCESS! All contracts deployed and linked.");
  console.log("Use these addresses in your index.html:");
  console.log("COIN:", coinAddress);
  console.log("NFT:", nftAddress);
  console.log("VAULT:", vaultAddress);
  console.log("-----------------------------------------");
}



main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});