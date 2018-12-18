pragma solidity ^0.4.24;

contract ContestFactoryBasic {

    event ContestCreated(address contestAddress, string id);

    function createContest(string _id, uint256 _buyin, bytes32[] _data) public
    returns(address contestAddress);
}
