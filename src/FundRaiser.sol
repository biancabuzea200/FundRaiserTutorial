// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IChronicle {
    function read() external view returns (uint value);
}

// https://github.com/chronicleprotocol/self-kisser/blob/main/src/ISelfKisser.sol
interface ISelfKisser {
    /// @notice Kisses caller on oracle `oracle`.
    function selfKiss(address oracle) external;
}

contract FundRaiser {
    IChronicle public chronicle; // The price feed we will use.
    ISelfKisser public selfKisser;
    address public owner;

    uint private constant RAISE_GOAL_USD = 4000 ether; // 4000 USD in wei (18 decimal places).

    constructor() {
        /**
         * @notice The SelfKisser granting access to Chronicle oracles.
         * SelfKisser_1: 0x0Dcc19657007713483A5cA76e6A7bbe5f56EA37d
         * Network: Sepolia
         */
        selfKisser = ISelfKisser(address(0x0Dcc19657007713483A5cA76e6A7bbe5f56EA37d));

        /**
         * Network: Sepolia
         * Aggregator: ETH/USD
         * Address: 0xdd6D76262Fd7BdDe428dcfCd94386EbAe0151603
         */
        chronicle = IChronicle(address(0xdd6D76262Fd7BdDe428dcfCd94386EbAe0151603));
        selfKisser.selfKiss(address(chronicle));
        owner = msg.sender;
    }

    receive() external payable {
        // Convert amount raised in ETH to USD.
        uint amountRaisedUSD_ = _weiToUSD(address(this).balance);
        // Require that the amount raised in USD is less than the goal.
        require(amountRaisedUSD_ < RAISE_GOAL_USD, "raise goal already reached!");
    }

    // -- Modifier --

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // -- Functions --

    function withdraw() external onlyOwner {
        (bool success,) = owner.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    // -- State --

    /// @notice Returns the amount raised in USD with 18 decimal places.
    function amountRaisedUSD() public view returns (uint) {
        uint amountRaised = address(this).balance; // Amount raised in ETH
        return _weiToUSD(amountRaised); // Convert to USD.
    }

    /// @notice Returns the amount raised in USD with 18 decimal places.
    function raiseGoal() public pure returns (uint) {
        return RAISE_GOAL_USD;
    }

    // -- Helpers --

    /// @dev Converts wei amount to USD using the price feed.
    /// @dev The USD amount has 18 decimal places.
    function _weiToUSD(uint amountEth) internal view returns (uint) {
        // Read the price feed to get the ETH/USD price.
        uint ethUsd = _read(); // Price feed has 10**18 decimal places  (eth / usd) * 10^18 
        uint amountUSD = (amountEth * ethUsd) / 10**18; // Convert ETH to USD
        return amountUSD; // Return the USD amount with 18 decimal places
    }

    function _read() internal view returns (uint val) {
        val = chronicle.read();
    }

}
