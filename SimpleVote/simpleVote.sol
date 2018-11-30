pragma solidity ^0.4.24;
// deploy 시 호출된다
contract simpleVote {
    
    struct voter {
        address voterAddress;
        uint tokenBought;
    }
    
    mapping (address => voter) public voters; // 투표자들의 주소
    mapping (bytes32 => uint) public votesReceived; // 후보자 특표수
    
    bytes32[] public candidateNames; // 후보자 배열
    
    uint public totalToken; // 토큰 총 개수
    uint public balanceTokens; // 남은 토큰 수
    uint public tokenPrice; // 토큰 가격 ex) 0.01 ether
    
    // 이더를 넘길 때 wei로 넘겨야함... uint라서 0.01이더를 하려면 10의16승? 을 전달해야해
    constructor(uint _totalToken, uint _tokenPrice) public // Tx 생성시 호출자 || param: Token 총 개수, Token 1개당 가격
    {
        totalToken = _totalToken;
        balanceTokens = _totalToken;
        tokenPrice = _tokenPrice;
        
        candidateNames.push("Monday");
        candidateNames.push("Tuesday");
        candidateNames.push("Wednesday");
        candidateNames.push("Thursday");
        candidateNames.push("Friday");
        candidateNames.push("Saturday");
        candidateNames.push("Sunday");
    }
    
    // 송금을 하기 위해 payable로 선언
    function buy() payable public returns (int) 
    {
        uint tokensToBuy = msg.value / tokenPrice; // 구매할 토큰의 개수 || msg.value = total 가격 - gas fee
        require(tokensToBuy <= balanceTokens); // 내가 충분한 sellable token이 있는지
        voters[msg.sender].voterAddress = msg.sender;
        voters[msg.sender].tokenBought += tokensToBuy;
        balanceTokens -= tokensToBuy;
    }
    
    function getVotesReceivedFor() view public returns (uint, uint, uint, uint, uint, uint, uint)
    {
        return (votesReceived["Monday"],
        votesReceived["Tuesday"],
        votesReceived["Wednesday"],
        votesReceived["Thursday"],
        votesReceived["Friday"],
        votesReceived["Saturday"],
        votesReceived["Sunday"]);
    }
    
    // 투표시 호출
    function vote(bytes32 candidateName, uint tokenCountForVote) public
    {
        uint index = getCandidateIndex(candidateName);
        require(index != uint(-1)); // 유효한 후보자?
        
        require(tokenCountForVote <= voters[msg.sender].tokenBought); // 사용할 토큰 넉넉?
        
        votesReceived[candidateName] += tokenCountForVote;
        voters[msg.sender].tokenBought -= tokenCountForVote;
    }
    
    function getCandidateIndex(bytes32 candidate) view public returns (uint) // 해당 후보자의 index 반환
    {
        for(uint i=0; i < candidateNames.length; i++)
        {
            if(candidateNames[i] == candidate)
            {
                return i;
            }
        }
        
        return uint(-1); // 후보자가 없는 경우 -1 반환
    }
    
    function getCandidatesInfo() view public returns (bytes32[]) // 후보자 이름들 반환
    {
        return candidateNames;
    }
    
    function getTotalToken() view public returns(uint)
    {
        return totalToken;
    }
    
    function getBalanceTokens() view public returns(uint)
    {
        return balanceTokens;
    }
    
    function getTokenPrice() view public returns(uint)
    {
        return tokenPrice;
    }
    
    function getTokenBought() view public returns(uint)
    {
        return voters[msg.sender].tokenBought;
    }
}