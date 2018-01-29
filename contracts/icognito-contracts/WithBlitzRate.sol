pragma solidity ^0.4.18;

import './TokenCrowdsale.sol';


/**
 * @dev Blitz rate mixin for token purchase.
 * Be careful with different set tokens and rate logic mixing.
 */
contract WithBlitzRate is TokenCrowdsale {

    // how many token units a buyer gets for collector unit (a rate divisor can be used)
    uint256 blitzRate;

    // calc tokens
    function calcTokens(uint128 participant, uint8 collector, uint256 amount) internal returns (uint256) {
        if (blitzRate > 0) {
            uint256 tokensAmount = amount.mul(blitzRate);
            blitzRate = 0;
            return tokensAmount;
        }
        return super.calcTokens(participant, collector, amount);
    }
}
