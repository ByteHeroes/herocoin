pragma solidity ^0.4.24;

import "zeppelin/token/ERC20Basic.sol";
import "./HeroCoinBasic.sol";

contract ContestBasic {
    // variables

    string public id;

    uint256 public buyin;

    bytes32[] public data;

    mapping(address => bool) public participants;

    mapping(address => bool) public paid;

    event Participated(address participantAddress);

    event WinnerPaid(address participantAddress);

    function addParticipant_gaO(address _participant) public;

    function payout(address _to, uint256 _amount) public;
}
