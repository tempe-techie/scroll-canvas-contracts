require("@nomicfoundation/hardhat-toolbox");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: 'hardhat',

  paths: {
    sources: './src', // Set the folder containing your Solidity contracts
  },

  networks: {
    hardhat: {
      gas: "auto", // gas limit
    },
    localhost: {
      gas: "auto", // gas limit
    },
  },

  solidity: {
    compilers: [
      {
        version: "0.8.19",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
    ],
  }
  
};