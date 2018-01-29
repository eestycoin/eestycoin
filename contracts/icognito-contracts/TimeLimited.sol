pragma solidity ^0.4.18;


contract TimeLimited {

    // start and end timestamps
    // start time is inclusive
    // end time is not inclusive
    uint256 public startTime;
    uint256 public endTime;


    // constructor
    function TimeLimited(uint256 _startTime, uint256 _endTime) public {
        require(_endTime >= _startTime);

        startTime = _startTime;
        endTime = _endTime;
    }

    // @return true if event occurs within allowed period
    function withinPeriod() public view returns (bool) {
        return now >= startTime && now < endTime;
    }

    // @return true if event has ended
    function hasEnded() public view returns (bool) {
        return now >= endTime;
    }
}
