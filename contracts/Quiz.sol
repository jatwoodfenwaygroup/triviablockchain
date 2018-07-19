pragma solidity ^0.4.24;

contract Quiz{
    struct quiz{
        string question;
        string[4] optionList;
        uint8 answer;
    }
    mapping(address=>uint)public balances;
    address public owner;
    address[] public adminList;
    quiz[4] private quizList;
    address[] public winnerList;
    uint public reward;
    
    constructor(uint blockReward) public{
        owner = msg.sender;
        adminList.push(msg.sender);
        reward = blockReward;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyAdmin(){
        require(checkAdminList(msg.sender));
        _;
    }
    
    function checkAdminList(address isContained) private view returns(bool) {
        for(uint i = 0; i < adminList.length; i++){
            if(isContained == adminList[i])
                return true;
        }
    }
    
    function setAdminList(address newAdmin) public onlyOwner{
        adminList.push(newAdmin);
    }
    
    function setupQuiz(string newQuestion, string firstOption, string secondOption, string thirdOption, string fourthOption, uint8 newAnswer, uint index) public onlyAdmin{
        quizList[index].question = newQuestion;
        quizList[index].optionList[0] = firstOption;
        quizList[index].optionList[1] = secondOption;
        quizList[index].optionList[2] = thirdOption;
        quizList[index].optionList[3] = fourthOption;
        quizList[index].answer = newAnswer;
    }
    
    function checkAnswer(uint8[4] answerToCheck) public returns(uint){
        uint sum = 0;
        for( uint8 i = 0; i < 4; i++){
            if(answerToCheck[i] == quizList[i].answer)
                sum++;
        }
        uint score = sum%4;
        if(score == 0){
            winnerList.push(msg.sender);
        }
        return score;
    }
    
    function awardPoints() public onlyAdmin {
        uint award = (reward/winnerList.length);
        for(uint i = 0; i < winnerList.length; i++){
            mint(winnerList[i], award);
        }
    }
    
    function mint(address receiver, uint quantity)private payable{
        balances[receiver]+=quantity;
    }

}