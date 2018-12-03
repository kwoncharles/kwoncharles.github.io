pragma solidity ^0.4.24;

contract Auction {

    struct bidder {
        address bidderAddress;
        uint tokenBought;
    }

    mapping (address => bidder) public bidders;

    mapping (bytes32 => uint) public highestBids;
    mapping (bytes32 => uint) public myBids;

    bytes32[] public itemList;

    uint public totalToken;
    uint public balanceTokens;
    uint public tokenPrice;
    

    constructor(uint _totalToken, uint _tokenPrice) public {
        totalToken = _totalToken;
        balanceTokens = _totalToken;
        tokenPrice = _tokenPrice;

        itemList.push("iphone7");
        itemList.push("iphone8");
        itemList.push("iphoneX");
        itemList.push("galaxyS9");
        itemList.push("galaxyNote9");
        itemList.push("LGG7");
    }

    function buy() public payable {
        uint tokensToBuy = msg.value / tokenPrice;
        require(tokensToBuy <= balanceTokens, "Not enough tokens.");
        bidders[msg.sender].bidderAddress = msg.sender;
        bidders[msg.sender].tokenBought += tokensToBuy;
        balanceTokens -= tokensToBuy;
    }

    function getHighestBids() public view returns (uint, uint, uint, uint, uint, uint) {
        // uint[] returnList;
        // uint length = itemList.length;

        // for( uint i = 0; i < length; i++) {
        //     returnList.push(highestBids[itemList[i]]);
        // }

        // return returnList;

        return (
          highestBids["iPhone7"],
          highestBids["iPhone8"],
          highestBids["iPhoneX"],
          highestBids["GalaxyS9"],
          highestBids["GalaxyNote9"],
          highestBids["LGG7"]
        );
    }

    function getMyBids() public view returns (uint, uint, uint, uint, uint, uint) {
        // uint[] returnList;
        // uint length = itemList.length;

        // for( uint i = 0; i < length; i++) {
        //     returnList.push(myBids[itemList[i]]);
        // }

        // return returnList;
        
        return (
          myBids["iPhone7"],
          myBids["iPhone8"],
          myBids["iPhoneX"],
          myBids["GalaxyS9"],
          myBids["GalaxyNote9"],
          myBids["LGG7"]
        );
    }

    function bid(bytes32 itemName, uint tokenCountForBid) public {
        require(getItemIndex(itemName) != uint(-1), "itemName is invalid");
        // Bid have to be higher than the previous highest bid
        require((tokenCountForBid < bidders[msg.sender].tokenBought) && (tokenCountForBid > highestBids[itemName]), "Your bidding price is lower than the previous bid");

        myBids[itemName] = tokenCountForBid;
        highestBids[itemName] = tokenCountForBid;
        bidders[msg.sender].tokenBought -= tokenCountForBid;
    }

    function getItemIndex(bytes32 item) public view returns (uint) {
        for(uint i = itemList.length-1 ; i>=0 ; i--) {
            if(itemList[i] == item) {
                return i;
            }
        }
        return uint(-1);
    }

    function getItemsInfo() public view returns (bytes32[]) {
        return itemList;
    }

    function getTotalToken() public view returns(uint) {
        return totalToken;
    }

    function getBalanceTokens() public view returns(uint) {
        return balanceTokens;
    }

    function getTokenPrice() public view returns(uint) {
        return tokenPrice;
    }

    function getTokenBought() public view returns(uint) {
        return bidders[msg.sender].tokenBought;
    }
}