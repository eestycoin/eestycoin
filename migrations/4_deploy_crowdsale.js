const timestamp = require('unix-timestamp');

const SafeMath = artifacts.require('./SafeMath.sol');
const SafeERC20 = artifacts.require('./SafeERC20.sol');
const EestyCoinCrowdsale = artifacts.require('./EestyCoinCrowdsale.sol');
const EestyCoinToken = artifacts.require('./EestyCoinToken.sol');

module.exports = function (deployer, network, accounts) {
    let token;
    let wallet;
    const ratesDivisor = 1000;

    let startTime;
    let endTime;

    let firstClaimTime;
    let secondClaimTime;

    let firstBonusTime;
    let secondBonusTime;
    let thirdBonusTime;

    if (network === 'mainnet') {
        startTime = timestamp.now(); // 2018-02-01 is the official start time

        firstBonusTime = timestamp.fromDate('2018-02-06');
        secondBonusTime = timestamp.fromDate('2018-02-17');
        thirdBonusTime = timestamp.fromDate('2018-03-01');

        endTime = timestamp.fromDate('2018-04-01');

        firstClaimTime = timestamp.fromDate('2018-08-01');
        secondClaimTime = timestamp.fromDate('2019-02-01');
    } else if (network === 'ropsten') {
        startTime = timestamp.now('+10m');

        firstBonusTime = timestamp.now('+20m');
        secondBonusTime = timestamp.now('+30m');
        thirdBonusTime = timestamp.now('+40m');

        endTime = timestamp.now('+50m');

        firstClaimTime = timestamp.now('+60m');
        secondClaimTime = timestamp.now('+70m');
    } else {
        startTime = timestamp.now('+1m');

        firstBonusTime = timestamp.now('+2m');
        secondBonusTime = timestamp.now('+3m');
        thirdBonusTime = timestamp.now('+4m');

        endTime = timestamp.now('+5m');

        firstClaimTime = timestamp.now('+6m');
        secondClaimTime = timestamp.now('+7m');
    }

    if (network === 'develop' || network === 'development')
        wallet = accounts[0];
    else if (network === 'ropsten')
        wallet = '0x7c0f6C0E6c86b96a9ec025A0c09b582429c42BAC';
    else if (network === 'mainnet')
        wallet = '0x724F8145B2a28E4935BCF09477eFD51Ce68B2cdD';

    deployer.link(SafeMath, EestyCoinCrowdsale);
    deployer.link(SafeERC20, EestyCoinCrowdsale);

    deployer.then(function () {
        return EestyCoinToken.deployed();
    }).then(function (_token) {
        token = _token;
    }).then(function () {
        return deployer.deploy(EestyCoinCrowdsale,
            startTime,
            endTime,

            ['0x455448', '0x535300', '0x425443'], // ETH, SS, BTC
            token.address,
            wallet,
            ratesDivisor,

            firstClaimTime,
            secondClaimTime,

            firstBonusTime,
            secondBonusTime,
            thirdBonusTime,

            { gas: 2800000 }
        );
    });

    // DO NOT FORGET MAKE APPROVE FROM TOKEN TO CROWDSALE BY HAND
};
