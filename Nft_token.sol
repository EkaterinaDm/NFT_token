pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Nft_token {
    
    struct Token{
        string name;
        string autor;
        string group;
        uint cost;
    }

    Token[] tokensArr;
    mapping (uint => uint) tokenToOwner;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier OnlyOwner(uint tokenId) {
        require(msg.pubkey() == tokenToOwner[tokenId], 103, "Avaiable only to the owner");
        tvm.accept();
        _;
    }

    function createToken(string name, string autor, string group) public {
        tvm.accept();
        // проверка на уникальность имени
        for (uint i=0; i<tokensArr.length; i++){
            require(name != tokensArr[i].name, 104, "The given name is already in use");
        }   
        // добавление нового элемента в массив     
        tokensArr.push(Token(name, autor, group, 0));
        uint keyAsLastNum = tokensArr.length -1;
        tokenToOwner[keyAsLastNum] = msg.pubkey();
    }

    function getTokenInfo(uint tokenId) public view returns (string tokenName, string tokenAutor, string tokenGroup, uint tokenCost) {
        tvm.accept();
        tokenName = tokensArr[tokenId].name;
        tokenAutor = tokensArr[tokenId].autor;
        tokenGroup = tokensArr[tokenId].group;
        tokenCost = tokensArr[tokenId].cost;
    }

    function putUpForSale(uint tokenId, uint cost) public OnlyOwner(tokenId){
        tokensArr[tokenId].cost = cost;
    }
}
