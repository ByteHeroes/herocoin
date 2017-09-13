import "./HeroCoin.sol";


pragma solidity ^0.4.11;


contract ExampleContest {

    address public admin;

    //TODO: replace this with ENS?
    HeroCoin public heroCoin;

    string public contestData = "Example Contest";

    // data structures to manage contests
    enum ContestStates {
    Preparation,
    Running,
    Completed,
    Abort
    }

    ContestStates public state;

    uint256 tokensParticipated;

    mapping (address => uint256) participants;

    event ContestStateTransition(ContestStates oldState, ContestStates newState);

    modifier requireContestState(ContestStates requiredState) {
        require(state == requiredState);
        _;
    }

    modifier requireContestAdmin(address user) {
        require(admin == user);
        _;
    }

    // how to make this data final?
    // customRewards should not be modifiable during funds withdrawals.
    mapping (address => uint256) public customRewards;

    function ExampleContest(address _heroCoin) {
        admin = msg.sender;
        heroCoin = HeroCoin(_heroCoin);
        //    heroCoin.balanceOf(msg.sender) > 0;
        heroCoin.registerContest();
    }


    function moveToContestState(ContestStates newState)
    internal
    {
        if (state == ContestStates.Completed) {
            return;
        }
        ContestStateTransition(state, newState);
        state = newState;
    }

    function startContest()
    requireContestState(ContestStates.Preparation)
    requireContestAdmin(msg.sender)
    {
        moveToContestState(ContestStates.Running);
    }

    /*    function distributeContestCoinsFixed(address contest)
        internal {
            // follows fixed rules for distribution
            // We cannot iterate on participants but we know total amount.
            // We can remove percentage of total amount and credit herocoin account.
            // Each other account can get a reduced amount at withdrawal time.
        }*/

    /* // users can call this function to obtain their funds after contest completion.
     function withdrawContestResults(address contest)
     requireContestState(contest, ContestStates.Completed)
     {
         // remove fixed fee already distributed in distributeContestCoinsFixed
         // make sure contest.customRewards[msg.sender] <= tokensParticipated
         // other sanity checks?
         // distribute tokens to user.
     }*/

    function endContest(address winner)
    requireContestState(ContestStates.Running)
    requireContestAdmin(msg.sender)
    {
        distributeCoins(winner);
        moveToContestState(ContestStates.Completed);
    }

    function distributeCoins(address winner)
    internal {
        uint256 amountWon = heroCoin.balanceOf(this) * 100 / 101;
        //rounded down
        heroCoin.transfer(winner, amountWon);
        //if exactly 1, 102, 203, 304, 405, 506 coins were put into this contest, we might have a leftover of 1 coin
        //maybe pay this out to the public
        uint256 rest = heroCoin.balanceOf(this);
        if (rest > 0) {
            heroCoin.payRake(rest);
        }
    }


    // admin (and/or HeroCoin admin ? ) can abort contest
    function abortContest()
    requireContestAdmin(msg.sender)
    {
        if (state == ContestStates.Completed) {
            return;
            // completed state is final.
        }
        moveToContestState(ContestStates.Abort);
    }


}
