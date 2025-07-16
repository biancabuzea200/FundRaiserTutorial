## Create a 'FundRaiser' Contract
In this workshop, we will create our FundRaiser contract that will help us collect funds in ETH up to a goal amount denominated in ETH. 

# How to Run it?
```
forge build 
forge test
```

## Make sure to rename the .env.example to .env and add your environment variables

## Export the environment variables
```
source .env 
```


## Build the projects's smart contracts
```
forge build
```

## Deploy FundRaiser.sol to Sepolia
```
forge script --chain sepolia script/deploy_fundRaiser.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv
```


## Send some ETH to the FundRaiser's address 
 ```
 cast send $FUND_RAISER_ADDRESS  --value 0.01ether  --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY
 ```
