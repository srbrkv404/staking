import { ethers } from 'hardhat';
import { config } from 'dotenv';
const getContract_staking = require('./getContract.ts');

config();

async function setValues() {
    const contract = await getContract_staking();

    try {
        const [acc1, acc2] = await ethers.getSigners();

        const rewardTime = 60;
        const unstakeTime = 60;
        const rewardPercent = 10 ** 4;

        console.log(`Seting values...`);

        const tx1 = await contract.connect(acc2).setRewardTime(rewardTime);
        await tx1.wait();

        const tx2 = await contract.connect(acc2).setUnstakeTime(unstakeTime);
        await tx2.wait();

        const tx3 = await contract.connect(acc2).setRewardPercent(rewardPercent);
        await tx3.wait();

        console.log(`Transactions finished.`);
    } catch (error) {
        console.error(`Error sending transaction: ${error}`);
    }

}

setValues()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    }); 