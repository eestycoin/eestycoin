pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/token/StandardToken.sol';
import 'zeppelin-solidity/contracts/ownership/CanReclaimToken.sol';

contract EestyCoinToken is StandardToken, CanReclaimToken {

    string public name = "EESTYCOIN";
    string public symbol = "EEC";
    uint256 public decimals = 18;

    uint8 public emissionStage;
    uint256[3] public emissionStages;

    modifier canDoEmission() {
        require(emissionStage < 3);
        _;
    }

    event Emission(uint8 stage, uint256 amount);

    function EestyCoinToken() {
        emissionStages[0] = 10000000000000000000000000; // totalSupply 10 000 000
        emissionStages[1] = 990000000000000000000000000; // totalSupply 1 000 000 000
        emissionStages[2] = 7000000000000000000000000000; // totalSupply 8 000 000 000
    }

    function nextStageEmission() canDoEmission onlyOwner public {
        uint256 emission = emissionStages[emissionStage];

        totalSupply = totalSupply.add(emission);
        balances[owner] = balances[owner].add(emission);
        emissionStage = emissionStage + 1;

        Emission(emissionStage, emission);
        Transfer(0x0, owner, emission);
    }
}
