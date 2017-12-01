var HDWalletProvider = require("truffle-hdwallet-provider");

var infura_apikey = "";
var mnemonic = "";


module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*" // Match any network id
        },
        ropsten: {
            provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/" + infura_apikey),
            network_id: 3,
            gas: 88000,
            gasPrice: 20000000000 // 20 Gwei
        },
        mainnet: {
            provider: new HDWalletProvider(mnemonic, "https://mainnet.infura.io/" + infura_apikey),
            network_id: 1,
            gas: 88000,
            gasPrice: 20000000000 // 20 Gwei
        }
    }
};
