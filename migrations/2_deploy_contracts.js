const HeroCoin = artifacts.require("./HeroCoin.sol");

module.exports = function (deployer, network, account) {

    if (network === "live") {
        const stateControl = "0x10CA9409265c2938167856725945db35da3Ca149";
        const whitelist = "0xD076556513165EE138cFB054A84f7B48154c4667";
        const withdraw = "0x52245Ee29f243ff3A55B720C32DEe77EB1DCe334";
        const initialHolder = "0x38b50101cCE32A15e906A32bFda0939D01a1776f";

        console.log("params: ");
        console.log(network);
        console.log(account);

        console.log("whitelist account: ", whitelist);

        const heroAddress = deployer.deploy(HeroCoin,
            stateControl,
            whitelist,
            withdraw,
            initialHolder
        );

    } else if (network === "ropsten") {
        // preparation for ropsten deployment
        //
        const stateControl = "0x14703966b27ea0be3ec0d0fd10ba03549ff58ea6";
        const whitelist = "0xf327251dfac3b0235825fdfe3144f2d5bf14d690";
        const withdraw = "0xd7090db6ce6c23ee44e4ae532eadab295fd80b70";
        const initialHolder = "0x230e1a56d05a809ce560d7da8075886483180b12";

        console.log("params: ");
        console.log(network);
        console.log(account);

        // possible etherscan constructor format:
        // 00000000000000000000000014703966b27ea0be3ec0d0fd10ba03549ff58ea6000000000000000000000000f327251dfac3b0235825fdfe3144f2d5bf14d690000000000000000000000000d7090db6ce6c23ee44e4ae532eadab295fd80b70000000000000000000000000230e1a56d05a809ce560d7da8075886483180b12
        console.log("whitelist account: ", whitelist);

        const heroAddress = deployer.deploy(HeroCoin,
            stateControl,
            whitelist,
            withdraw,
            initialHolder
        );

    } else if (network === "development") {
        // testrpc
        const doNotUse = account[0];
        const stateControl = account[1];
        const whitelist = account[2];
        const withdraw = account[3];
        const initialHolder = account[4];
        const user1 = account[5];
        const user2 = account[6];
        const user3 = account[7];
        const heroAddress = deployer.deploy(HeroCoin,
            stateControl,
            whitelist,
            withdraw,
            initialHolder
        )
    }
};
