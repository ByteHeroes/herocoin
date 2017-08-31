#Herocoin Contract
This repository contains the implementation of the hercoin ICO , ERC20 contracts as well as a example contract for future contests.

#Building and testing

    sudo npm install -g truffle@3.4.5    
    sudo npm install -g ethereumjs-testrpc
    npm install .                        
    truffle install zeppelin
                            
start testrpc with
 
    ./scripts/start_testrpc.sh
    
run tests with
 
    truffle test

currently deployed on ropsten to 0xe93099d7e2afbfe88044d40ab5141f1c3c1ac39b