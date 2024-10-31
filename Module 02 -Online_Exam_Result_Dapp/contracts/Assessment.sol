pragma solidity ^0.8.9;

contract ExamResult {

    address payable public owner; 
    uint256 public balance;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);

    struct Student {
        uint256 id;
        string name;
        uint256 score;
        bool graded;
    }

    mapping(uint256 => Student) public students;
    uint256 public studentCount;

    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
    }


    function addStudent(uint256 _id, string memory _name) public  {
        require(students[_id].id == 0, "Student with this ID already exists.");
        studentCount++;
        students[_id] = Student(_id, _name, 0, false);
    }

    function recordResult(uint256 _id, uint256 _score) public  {
        require(students[_id].id != 0, "Student not found.");
        require(!students[_id].graded, "Student already graded.");
        students[_id].score = _score;
        students[_id].graded = true;
    }

    function getStudentResult(uint256 _id) public view returns (string memory, uint256, bool) {
        require(students[_id].id != 0, "Student not found.");
        return (students[_id].name, students[_id].score, students[_id].graded);
    }

    function getBalance() public view returns(uint256){
        return balance;
    }

    function deposit(uint256 _amount) public payable {
        uint _previousBalance = balance;

        // perform transaction
        balance += _amount;

        // assert transaction completed successfully
        assert(balance == _previousBalance + _amount);

        // emit the event
        emit Deposit(_amount);
    }

    // custom error
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public  {
        uint _previousBalance = balance;
        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }

        // withdraw the given amount
        balance -= _withdrawAmount;

        // assert the balance is correct
        assert(balance == (_previousBalance - _withdrawAmount));

        // emit the event
        emit Withdraw(_withdrawAmount);
    }
}
