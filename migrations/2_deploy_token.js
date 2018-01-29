const EestyCoinToken = artifacts.require('./EestyCoinToken.sol');

module.exports = function(deployer) {
  deployer.deploy(EestyCoinToken, { gas: 2000000 });
};
