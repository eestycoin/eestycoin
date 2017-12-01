var EestyCoinToken = artifacts.require("./EestyCoinToken.sol");

module.exports = function(deployer) {
  deployer.deploy(EestyCoinToken, { gas: 1170000 });
};
