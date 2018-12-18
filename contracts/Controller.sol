pragma solidity ^0.4.24;

import "./ContestFactoryBasic.sol";
import "./ContestBasic.sol";
import "./HeroCoinBasic.sol";

contract Controller {

    HeroCoinBasic playToken;

    address public contestFactoryControl;

    address public tokenAssignmentControl;

    event ContestCreated(address contestAddress, string id);

    mapping(address => bool) public deployedContests;

    // constructor
    function Controller(
        HeroCoinBasic _playToken
      , address _contestFactoryControl
      , address _tokenAssignmentControl
    ) public
    {
        playToken = _playToken;
        require(address(playToken) != 0x0);
        // would be nice to do |require(playToken.symbol() == "PLAY");|
        // but that results in |TypeError: Operator == not compatible with types inaccessible dynamic type and literal_string "PLAY"|
        contestFactoryControl = _contestFactoryControl;
        tokenAssignmentControl = _tokenAssignmentControl;
    }


    modifier onlyContestFactoryControl() {
        require(msg.sender == contestFactoryControl,
            "Sender is not authorized. Only contestFactoryControl is allowed to call this function");
        _;
    }

    modifier onlyTokenAssignmentControl() {
        require(msg.sender == tokenAssignmentControl,
            "Sender is not authorized. Only tokenAssignmentControl is allowed to call this function");
        _;
    }


    function createContest(ContestFactoryBasic _contestFactory, string _id, uint256 _buyin, bytes32[] _data)
    public
    onlyContestFactoryControl
    {
        require(address(_contestFactory) != 0x0,
            "Contest factory address is 0x0");
        address newContest = _contestFactory.createContest(_id, _buyin, _data);
        emit ContestCreated(newContest, _id);
        deployedContests[newContest] = true;
    }

    function participateInContest_M2g(ContestBasic _contest, address _participant)
    public
    onlyTokenAssignmentControl
    {
        // only allow contests that this controller has deployed
        require(deployedContests[_contest] == true,
            "This controller has not deployed this contest");
        playToken.transferFrom(_participant, address(_contest), _contest.buyin());
        _contest.addParticipant_gaO(_participant);
    }

    function participateInContest(ContestBasic _contest)
    public
    {
        require(deployedContests[_contest] == true,
            "This controller has not deployed this contest");
        playToken.transferFrom(msg.sender, address(_contest), _contest.buyin());
        _contest.addParticipant_gaO(msg.sender);
    }

    // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.
    function rescueToken(ERC20Basic _foreignToken, address _to)
    public
    onlyTokenAssignmentControl
    {
        _foreignToken.transfer(_to, _foreignToken.balanceOf(this));
    }

    // Make sure this contract cannot receive ETH.
    function() payable public
    {
        revert();
    }
}
