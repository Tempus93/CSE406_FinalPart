// scripts/link.cjs
const hre = require("hardhat");

async function main() {
    const nftAddress = "0xE21b046C4e3b8fF809F84a63186C55b466928AF7";
    const vaultAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"; // Replace with your deployed Vault address

  const nft = await hre.ethers.getContractAt("EngineeringNFT", nftAddress);
  
  console.log("Transferring ownership to Vault...");
  const tx = await nft.transferOwnership(vaultAddress);
  await tx.wait();
  
  console.log("Vault is now authorized to mint NFTs!");
}

main().catch(error => { console.error(error); process.exit(1); });