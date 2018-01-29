pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';


/**
 * @title ParticipantsFunded
 * @dev ParticipantsFunded is a base contract for managing funding.
 * Records about funds are stored in collectors
 * which distinguished by origin of funds.
 * Contract supports up to 256 different collectors.
 * Participants take a part using its UUIDs.
 * ParticipantsFunded contract has no public participate function itself
 * and should be used as a pure base for a funding contracts.
 * Inspired by Zeppelin contracts.
 */
contract ParticipantsFunded is Ownable {
    using SafeMath for uint256;

    // collectors by symbols
    // 3 ascii chars for symbol
    bytes3[] public collectors;

    // participants funds by collectors
    mapping (uint128 => mapping(uint8 => uint256)) public funded;

    // funds raised by collectors
    mapping (uint8 => uint256) public raised;

    // event for participation logging
    event ParticipationEvent(uint128 indexed participant, uint8 indexed collector, uint256 amount);


    /**
     * @dev constructor
     * @param _collectors collectors by symbols
     */
    function ParticipantsFunded(bytes3[] _collectors) public {
        require(_collectors.length <= 256);
        collectors = _collectors;
    }

    // internal participate function
    // the main entry point where show begins
    // appropriate public function(s) should be created
    function _participate(uint128 participant, uint8 collector, uint256 amount) internal {
        require(participant != 0);
        require(amount > 0);
        require(validParticipation(participant));

        funded[participant][collector] = funded[participant][collector].add(amount);
        raised[collector] = raised[collector].add(amount);

        participation(participant, collector, amount);
        ParticipationEvent(participant, collector, amount);

        forwardFunds(participant);
    }

    // used if we want forward funds (if any) received during participation
    function forwardFunds(uint128 /** participant */) internal {
    }

    /**
     * @dev Can be overridden to add participation logic. The overriding function
     * should call super.participation() to ensure the chain of participation is
     * executed entirely.
     */
    function participation(uint128 /** participant */, uint8 /** collector */, uint256 /** amount */) internal {
    }


    // @return true if the participation is possible
    function validParticipation(uint128 /** participant */) internal view returns (bool) {
        return true;
    }
}
