pragma solidity ^0.4.18;

import './ClaimableTokenCrowdsale.sol';

contract WithSetClaimAddressByOwnerMixin is ClaimableTokenCrowdsale {
    // set participant `claim` address, owner plays
    function setClaimAddressByOwner(uint128 participant, address claimAddress) onlyOwner public {
        _setClaimAddress(participant, claimAddress);
    }
}
