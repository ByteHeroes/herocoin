pragma solidity ^0.4.24;

import "./ContestBasic.sol";
import "./HeroCoinBasic.sol";

contract Contest is ContestBasic {

    HeroCoinBasic playToken;

    address public tokenAssignmentControl;

    address public controllerContract;

    // constructor
    function Contest(
        HeroCoinBasic _playToken
    , address _controllerContract
    , address _tokenAssignmentControl
    , string _id
    , uint256 _buyin
    , bytes32[] _data
    ) public
    {
        // Require an operational token - would be nice if we could even require a PLAY token
        require(_playToken.state() == HeroCoinBasic.States.Operational);
        playToken = _playToken;
        controllerContract = _controllerContract;
        tokenAssignmentControl = _tokenAssignmentControl;
        id = _id;
        data = _data;
        buyin = _buyin;
        playToken.registerContest();
    }


    modifier onlyController() {
        require(msg.sender == controllerContract,
            "Sender is not authorized. Only controllerContract is allowed to call this function");
        _;
    }


    modifier onlyTokenAssignmentControl() {
        require(msg.sender == tokenAssignmentControl,
            "Sender is not authorized. Only TokenAssignmentControl is allowed to call this function");
        _;
    }


    function addParticipant_gaO(address _participant)
    public
    {
        require(participants[_participant] == false, "Given address is already participant in this contest");
        participants[_participant] = true;
        emit Participated(_participant);
    }

    // pay out to multiple address with the same amount and no points/rank.
    function payoutMultiSimple(address[] _to, uint256 _amount)
    public
    onlyTokenAssignmentControl
    {
        uint256 addrcount = _to.length;
        for (uint256 i = 0; i < addrcount; i++) {
            payout(_to[i], _amount);
        }
    }

    function payout(address _to, uint256 _amount)
    public
    onlyTokenAssignmentControl
    {
        require(paid[_to] == false, "address is already received payment");
        // we could check participants[_to] == true, but we don't - since we want to pay out to the house or others.
        // consider configuring "the house" in future incarnations
        // We do not need to check that we have the amount as .transfer would fail in this case.
        playToken.transfer(_to, _amount);
        paid[_to] = true;
        emit WinnerPaid(_to);
    }

    // Make sure this contract cannot receive ETH.
    function() payable public
    {
        revert();
    }
}
