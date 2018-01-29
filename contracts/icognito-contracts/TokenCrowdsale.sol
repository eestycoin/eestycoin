pragma solidity ^0.4.18;

import './ParticipantsFunded.sol';


contract TokenCrowdsale is ParticipantsFunded {

    // tokens sold
    uint256 public sold;

    // participants purchased tokens balances
    mapping (uint128 => uint256) public purchased;

    // event for token purchase logging
    event TokenPurchaseEvent(uint128 indexed participant, uint256 amount);


    // calculate tokens to be purchased
    // override this method to consider various rules
    // i.e. presale state, time slots discounts, special participants lists
    // defaults to amount
    function calcTokens(uint128 /** participant */, uint8 /** collector */, uint256 amount) internal returns (uint256) {
        return amount;
    }

    // purchase tokens for participant
    // override this method to create custom tokens purchasing mechanisms
    function buyTokens(uint128 participant, uint8 collector, uint256 amount) internal {
        require(validPurchase(participant));

        uint256 purchasedAmount = calcTokens(participant, collector, amount);

        sold = sold.add(purchasedAmount);
        purchased[participant] = purchased[participant].add(purchasedAmount);

        tokenPurchase(participant, purchasedAmount);
        TokenPurchaseEvent(participant, purchasedAmount);
    }

    // we're use participation function to purchase tokens
    function participation(uint128 participant, uint8 collector, uint256 amount) internal {
        super.participation(participant, collector, amount);
        buyTokens(participant, collector, amount);
    }

    /**
     * @dev Can be overridden to add purchase token logic. The overriding function
     * should call super.tokenPurchase() to ensure the chain of purchasing is
     * executed entirely.
     */
    function tokenPurchase(uint128 /** participant */, uint256 /** amount */) internal {
    }

    // @return true if the transaction can buy tokens
    function validPurchase(uint128 /** participant */) internal view returns (bool) {
        return true;
    }
}
