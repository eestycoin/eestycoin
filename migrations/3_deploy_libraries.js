const SafeMath = artifacts.require('./SafeMath.sol');
const SafeERC20 = artifacts.require('./SafeERC20.sol');

module.exports = function (deployer) {
    deployer.deploy(SafeMath);
    deployer.deploy(SafeERC20);
};
