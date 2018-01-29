pragma solidity ^0.4.18;

import './ParticipantsFunded.sol';

/**
 * @dev Mixin for ParticipantsFunded that allow to set collectors
 */
contract WithSetCollectorsMixin is ParticipantsFunded {
    function setCollectors(bytes3[] _collectors) onlyOwner public {
        require(_collectors.length <= 256);
        require(_collectors.length >= collectors.length);
        collectors = _collectors;
    }
}
