pragma solidity ^0.4.18;

import './TokenCrowdsale.sol';
import './WithBlitzRate.sol';
import './WithCollectorsTransactionsGuard.sol';

/**
 * @dev Mixin for TokenCrowdsale to participate by owner and blitz rate
 */
contract WithParticipateByOwnerAndBlitzRateMixin is TokenCrowdsale, WithBlitzRate, WithCollectorsTransactionsGuard {
    function participateByOwnerAndBlitzRate(uint128 participant, uint8 collector, uint256 amount, uint256 rate,
        uint256 transaction) onlyOwner public
    {
        require(!collectorsTransactions[collector][transaction]);

        collectorsTransactions[collector][transaction] = true;
        blitzRate = rate;

        _participate(participant, collector, amount);
    }
}
