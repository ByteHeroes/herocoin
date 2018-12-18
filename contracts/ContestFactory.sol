pragma solidity ^0.4.24;

import "./ContestFactoryBasic.sol";
import "./Contest.sol";
import "./HeroCoinBasic.sol";

contract ContestFactory is ContestFactoryBasic {

    HeroCoinBasic playToken;

    address public controllerContract;

    address public contestTokenControl;

    // constructor
    function ContestFactory(
        HeroCoinBasic _playToken
      , address _controllerContract
      , address _contestTokenControl
    ) public
    {
        playToken = _playToken;
        require(address(playToken) != 0x0);
        // would be nice to do |require(playToken.symbol() == "PLAY");|
        // but that results in |TypeError: Operator == not compatible with types inaccessible dynamic type and literal_string "PLAY"|
        controllerContract = _controllerContract;
        contestTokenControl = _contestTokenControl;
    }


    modifier onlyController() {
        require(msg.sender == controllerContract,
            "Sender is not authorized. Only controllerContract is allowed to call this function");
        _;
    }

    modifier onlyTokenAssignmentControl() {
        require(msg.sender == contestTokenControl,
            "Sender is not authorized. Only tokenAssignmentControl is allowed to call this function");
        _;
    }

    function createContest(string _id, uint256 _buyin, bytes32[] _data)
    public
    onlyController
    returns(address contestAddress)
    {
        address newContest = address(new Contest(playToken, controllerContract, contestTokenControl, _id, _buyin, _data));
        emit ContestCreated(newContest, _id);
        return newContest;
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
