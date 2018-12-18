pragma solidity ^0.4.11;


import "zeppelin/token/StandardToken.sol";


// only abstract interface, only elements needed in operational state
contract HeroCoinBasic is StandardToken {

    // data structures
    enum States {
    Initial, // deployment time
    ValuationSet,
    Ico, // whitelist addresses, accept funds, update balances
    Underfunded, // ICO time finished and minimal amount not raised
    Operational, // manage contests
    Paused         // for contract upgrades
    }

    string public constant name = "Herocoin";
    string public constant symbol = "PLAY";
    States public state;

    event ContestAnnouncement(address addr);

    function payRake(uint256 _value) public returns (bool success);

    // contest management functions

    function registerContest() public;
}
