pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20.sol';
import 'zeppelin-solidity/contracts/token/SafeERC20.sol';
import './ClaimableTokenCrowdsale.sol';


/**
 * @dev Mixin for ClaimableTokenCrowdsale
 */
contract WithClaimAllowanceTokenMixin is ClaimableTokenCrowdsale {
    using SafeERC20 for ERC20;

    ERC20 public token;
    address public tokenFrom;

    function WithClaimAllowanceTokenMixin(address _token, address _from) public {
        token = ERC20(_token);
        tokenFrom = _from;
    }

    function tokenClaim(uint128 participant, uint256 amount) internal {
        super.tokenClaim(participant, amount);
        token.safeTransferFrom(tokenFrom, msg.sender, amount);
    }
}
