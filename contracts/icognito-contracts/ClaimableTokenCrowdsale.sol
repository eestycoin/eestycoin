pragma solidity ^0.4.18;

import './TokenCrowdsale.sol';


contract ClaimableTokenCrowdsale is TokenCrowdsale {

    // tokens delivered
    uint256 public delivered;

    // participants claimed tokens balances
    mapping (uint128 => uint256) public claimed;

    // participant claim address
    mapping (uint128 => address) public participantClaimAddress;

    // participant who owns claim address
    mapping (address => uint128) public claimAddressParticipant;

    // event for token claim logging
    event TokenClaimEvent(uint128 indexed participant, uint256 amount);


    // set participant `claim` address, internal
    // appropriate public function(s) should be created
    // you may want to deny participation before `claim` address is set
    function _setClaimAddress(uint128 participant, address claimAddress) internal {
        require(participant != 0);
        require(claimAddress != address(0));
        require(participantClaimAddress[participant] == address(0));
        require(claimAddressParticipant[claimAddress] == 0);

        participantClaimAddress[participant] = claimAddress;
        claimAddressParticipant[claimAddress] = participant;
    }

    // calc tokens for current claim
    // defaults to unclaimed tokens
    function calcTokensForClaim(uint128 participant) internal returns (uint256) {
        return purchased[participant].sub(claimed[participant]);
    }

    // claim tokens, should be called from the registered `claim` address
    function claimTokens() public {
        address claimAddress = msg.sender;
        uint128 participant = claimAddressParticipant[claimAddress];

        require(participant != 0);
        require(validClaim(participant));

        uint256 tokensAmount = calcTokensForClaim(participant);

        require(tokensAmount > 0);

        delivered = delivered.add(tokensAmount);
        claimed[participant] = claimed[participant].add(tokensAmount);

        tokenClaim(participant, tokensAmount);
        TokenClaimEvent(participant, tokensAmount);
    }

    /**
     * @dev Can be overridden to add claim token logic. The overriding function
     * should call super.tokenClaim() to ensure the chain of claiming is
     * executed entirely.
     * This is the place for actual tokens movements.
     */
    function tokenClaim(uint128 /** participant */, uint256 /** amount */) internal {
    }

    // @return true if the claim is possible
    function validClaim(uint128 /** participant */) internal view returns (bool) {
        return true;
    }
}
