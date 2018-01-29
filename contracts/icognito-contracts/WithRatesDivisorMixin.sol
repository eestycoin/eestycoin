pragma solidity ^0.4.18;

import './TokenCrowdsale.sol';


/**
 * @dev Rate divisor mixin for token purchase.
 * This mixin should be used after any other rate mixin.
 * Be careful with different set tokens and rate logic mixing.
 */
contract WithRatesDivisorMixin is TokenCrowdsale {

    // divisor for rates
    uint256 public ratesDivisor;


    // constructor
    function WithRatesDivisorMixin(uint256 _divisor) public {
        require(_divisor > 0);

        ratesDivisor = _divisor;
    }

    // calc tokens
    function calcTokens(uint128 participant, uint8 collector, uint256 amount) internal returns (uint256) {
        return super.calcTokens(participant, collector, amount).div(ratesDivisor);
    }
}
