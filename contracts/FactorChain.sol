// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FactorChain {
    struct Factor {
        uint256 id;
        string expression;
        address creator;
        uint256[] parentIds;
        uint256 timestamp;
    }

    struct User {
        bool isSubscribed;
        uint256 credits;
    }

    uint256 public factorCount;
    uint256 public nonce;
    uint256 public difficulty = 1;
    mapping(uint256 => Factor) public factors;
    mapping(address => bool) public admins;
    mapping(address => User) public users;

    uint256 public subscriptionCost = 1 ether;
    uint256 public factorCreditCost = 0.1 ether;
    uint256 public miningReward = 1 ether;

    event FactorAdded(uint256 id, string expression, address indexed creator, uint256[] parentIds, uint256 timestamp);
    event FactorUpdated(uint256 id, string newExpression, uint256 timestamp);
    event UserSubscribed(address indexed user);
    event CreditsPurchased(address indexed user, uint256 credits);
    event FactorAccessed(address indexed user, uint256 factorId);
    event FactorMined(address indexed miner, uint256 factorId, uint256 reward);

    modifier onlyAdmin() {
        require(admins[msg.sender], "Only admin can perform this action");
        _;
    }

    constructor() {
        admins[msg.sender] = true;
    }

    function addFactor(string memory expression, uint256[] memory parentIds) public returns (uint256) {
        factorCount++;
        uint256 factorId = factorCount;
        factors[factorId] = Factor({
            id: factorId,
            expression: expression,
            creator: msg.sender,
            parentIds: parentIds,
            timestamp: block.timestamp
        });

        emit FactorAdded(factorId, expression, msg.sender, parentIds, block.timestamp);
        return factorId;
    }

    function updateFactor(uint256 factorId, string memory newExpression) public {
        Factor storage factor = factors[factorId];
        require(factor.creator == msg.sender || admins[msg.sender], "Only creator or admin can update this factor");

        factor.expression = newExpression;
        factor.timestamp = block.timestamp;

        emit FactorUpdated(factorId, newExpression, block.timestamp);
    }

    function getFactor(uint256 factorId) public returns (Factor memory) {
        require(users[msg.sender].isSubscribed || users[msg.sender].credits >= factorCreditCost, "Insufficient credits or not subscribed");

        if (!users[msg.sender].isSubscribed) {
            users[msg.sender].credits -= factorCreditCost;
        }

        emit FactorAccessed(msg.sender, factorId);
        return factors[factorId];
    }

    function subscribe() public payable {
        require(msg.value == subscriptionCost, "Incorrect subscription cost");
        users[msg.sender].isSubscribed = true;

        emit UserSubscribed(msg.sender);
    }

    function purchaseCredits() public payable {
        uint256 credits = msg.value / factorCreditCost;
        require(credits > 0, "Insufficient payment for credits");
        users[msg.sender].credits += credits;

        emit CreditsPurchased(msg.sender, credits);
    }

    function mineFactor(uint256 _nonce, string memory expression, uint256[] memory parentIds) public {
        bytes32 hash = keccak256(abi.encodePacked(nonce, msg.sender, _nonce));
        require(uint256(hash) % difficulty == 0, "Invalid solution");

        nonce++;

        factorCount++;
        uint256 factorId = factorCount;
        factors[factorId] = Factor({
            id: factorId,
            expression: expression,
            creator: msg.sender,
            parentIds: parentIds,
            timestamp: block.timestamp
        });

        users[msg.sender].credits += miningReward;

        emit FactorMined(msg.sender, factorId, miningReward);
    }

    function addAdmin(address newAdmin) public onlyAdmin {
        admins[newAdmin] = true;
    }

    function removeAdmin(address admin) public onlyAdmin {
        admins[admin] = false;
    }

    function withdraw() public onlyAdmin {
        payable(msg.sender).transfer(address(this).balance);
    }
}
