pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/CanReclaimToken.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';
import './icognito-contracts/TimeLimited.sol';
import './icognito-contracts/ClaimableTokenCrowdsale.sol';
import './icognito-contracts/WithSetCollectorsMixin.sol';
import './icognito-contracts/WithClaimAllowanceTokenMixin.sol';
import './icognito-contracts/WithSetClaimAddressByOwnerMixin.sol';
import './icognito-contracts/WithRatesDivisorMixin.sol';
import './icognito-contracts/WithParticipateByOwnerAndBlitzRateMixin.sol';


contract EestyCoinCrowdsale is CanReclaimToken, Pausable, TimeLimited, ClaimableTokenCrowdsale,
WithSetCollectorsMixin, WithClaimAllowanceTokenMixin, WithSetClaimAddressByOwnerMixin,
WithParticipateByOwnerAndBlitzRateMixin, WithRatesDivisorMixin
{

    uint256 public constant tokenUnit = 10 ** uint256(18);

    uint256 public firstClaimTime;
    uint256 public secondClaimTime;

    uint256 public firstBonusTime;
    uint256 public secondBonusTime;
    uint256 public thirdBonusTime;

    mapping (uint128 => bool) public hasDoneFirstClaim;


    function EestyCoinCrowdsale(
        uint256 _startTime, uint256 _endTime,
        bytes3[] _collectors,
        address _token, address _from,
        uint256 _divisor,
        uint256 _firstClaimTime, uint256 _secondClaimTime,
        uint256 _firstBonusTime, uint256 _secondBonusTime, uint256 _thirdBonusTime)
    TimeLimited(_startTime, _endTime)
    ParticipantsFunded(_collectors)
    WithClaimAllowanceTokenMixin(_token, _from)
    WithRatesDivisorMixin(_divisor)
    public
    {
        require(_firstClaimTime >= endTime);
        require(_secondClaimTime > _firstClaimTime);

        require(_firstBonusTime > startTime);
        require(_secondBonusTime > _firstBonusTime);
        require(_thirdBonusTime > _secondBonusTime);
        require(endTime > _thirdBonusTime);
        
        firstClaimTime = _firstClaimTime;
        secondClaimTime = _secondClaimTime;

        firstBonusTime = _firstBonusTime;
        secondBonusTime = _secondBonusTime;
        thirdBonusTime = _thirdBonusTime;
    }

    function calcTokens(uint128 participant, uint8 collector, uint256 amount) internal returns (uint256) {
        uint256 tokensAmount = super.calcTokens(participant, collector, amount);

        uint256 amountBonus = 0;
        if (tokensAmount >= 50000 * tokenUnit)
            amountBonus = tokensAmount.mul(35).div(100);
        else if (tokensAmount >= 20000 * tokenUnit)
            amountBonus = tokensAmount.mul(30).div(100);
        else if (tokensAmount >= 1000 * tokenUnit)
            amountBonus = tokensAmount.mul(25).div(100);

        uint256 timeBonus = 0;
        if (now < firstBonusTime)
            timeBonus = tokensAmount.mul(20).div(100);
        else if (now < secondBonusTime)
            timeBonus = tokensAmount.mul(15).div(100);
        else if (now < thirdBonusTime)
            timeBonus = tokensAmount.mul(10).div(100);

        return tokensAmount.add(amountBonus).add(timeBonus);
    }

    function calcTokensForClaim(uint128 participant) internal returns (uint256) {
        if ((now < firstClaimTime) || (now < secondClaimTime && hasDoneFirstClaim[participant]))
            return 0;

        uint256 tokensAmount = purchased[participant].sub(claimed[participant]);

        if (now < secondClaimTime) {
            hasDoneFirstClaim[participant] = true;
            return tokensAmount.div(2);
        }

        return tokensAmount;
    }

    function validParticipation(uint128 participant) internal view returns (bool) {
        return !paused && withinPeriod() && super.validParticipation(participant);
    }

    function validPurchase(uint128 participant) internal view returns (bool) {
        return !paused && withinPeriod() && super.validPurchase(participant);
    }

    function validClaim(uint128 participant) internal view returns (bool) {
        return !paused && hasEnded() && super.validClaim(participant);
    }
}
