const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to: ", nftContract.address);


// test mint for first nft
let txn = await nftContract.mintNFT()
await txn.wait()
console.log("Minted #1 NFT")

// mint again to see if increment is working
txn = await nftContract.mintNFT()
await txn.wait()
console.log("Minted #2 NFT")

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