import { useState, useEffect } from "react";
import { ethers } from "ethers";
import examResultAbi from "../artifacts/contracts/Assessment.sol/ExamResult.json";

export default function HomePage() {
  const [ethWallet, setEthWallet] = useState(undefined);
  const [account, setAccount] = useState(undefined);
  const [examResultContract, setExamResultContract] = useState(undefined);
  const [balance, setBalance] = useState(undefined);
  const [studentId, setStudentId] = useState(""); // For adding and fetching student ID
  const [studentName, setStudentName] = useState("");
  const [studentScore, setStudentScore] = useState("");
  const [recordId, setRecordId] = useState("");
  const [studentResult, setStudentResult] = useState(null);

  const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"; // Replace with your contract's address
  const examResultABI = examResultAbi.abi;

  const getWallet = async () => {
    if (window.ethereum) {
      setEthWallet(window.ethereum);
    }

    if (ethWallet) {
      const account = await ethWallet.request({ method: "eth_accounts" });
      handleAccount(account);
    }
  };

  const handleAccount = (account) => {
    if (account) {
      console.log("Account connected: ", account);
      setAccount(account);
    } else {
      console.log("No account found");
    }
  };

  const connectAccount = async () => {
    if (!ethWallet) {
      alert("MetaMask wallet is required to connect");
      return;
    }

    const accounts = await ethWallet.request({ method: "eth_requestAccounts" });
    handleAccount(accounts);

    getExamResultContract();
  };

  const getExamResultContract = () => {
    const provider = new ethers.providers.Web3Provider(ethWallet);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(contractAddress, examResultABI, signer);
    setExamResultContract(contract);
  };

  const getBalance = async () => {
    if (examResultContract) {
      const balance = await examResultContract.getBalance();
      setBalance(ethers.BigNumber.from(balance).toString());
    }
  };

  const addStudent = async () => {
    if (examResultContract) {
      const tx = await examResultContract.addStudent(studentId, studentName);
      await tx.wait();
      alert("Student added successfully");
      setStudentId("");
      setStudentName("");
    }
  };

  const recordResult = async () => {
    if (examResultContract) {
      const tx = await examResultContract.recordResult(
        ethers.BigNumber.from(recordId),
        ethers.BigNumber.from(studentScore)
      );
      await tx.wait();
      alert("Result recorded successfully");
      setRecordId("");
      setStudentScore("");
    }
  };

  const getStudentResult = async () => {
    if (examResultContract && studentId !== "") {
      try {
        const result = await examResultContract.getStudentResult(ethers.BigNumber.from(studentId));
        setStudentResult({
          name: result[0],
          score: ethers.BigNumber.from(result[1]).toString(),
          graded: result[2],
        });
      } catch (error) {
        console.error("Error retrieving student result:", error);
        alert("Student not found or invalid ID.");
      }
    } else {
      alert("Please enter a valid Student ID.");
    }
  };

  const deposit = async () => {
    if (examResultContract) {
      const tx = await examResultContract.deposit(ethers.utils.parseEther("1"));
      await tx.wait();
      getBalance();
    }
  };

  const withdraw = async () => {
    if (examResultContract) {
      const tx = await examResultContract.withdraw(ethers.utils.parseEther("1"));
      await tx.wait();
      getBalance();
    }
  };

  const initUser = () => {
    if (!ethWallet) {
      return <p>Please install MetaMask to use this application.</p>;
    }

    if (!account) {
      return <button onClick={connectAccount}>Connect MetaMask</button>;
    }

    if (balance === undefined) {
      getBalance();
    }

    return (
      <div>
        <p>Contract Balance: {balance} wei</p>

        {/* Section to add a student */}
        <div>
          <h3>Add a Student</h3>
          <input
            type="text"
            placeholder="Student ID"
            value={studentId}
            onChange={(e) => setStudentId(e.target.value)}
          />
          <input
            type="text"
            placeholder="Student Name"
            value={studentName}
            onChange={(e) => setStudentName(e.target.value)}
          />
          <button onClick={addStudent}>Add Student</button>
        </div>

        {/* Section to record a result */}
        <div>
          <h3>Record Result</h3>
          <input
            type="text"
            placeholder="Record ID"
            value={recordId}
            onChange={(e) => setRecordId(e.target.value)}
          />
          <input
            type="text"
            placeholder="Score"
            value={studentScore}
            onChange={(e) => setStudentScore(e.target.value)}
          />
          <button onClick={recordResult}>Record Result</button>
        </div>

        {/* Section to fetch student result */}
        <div>
          <h3>Get Student Result</h3>
          <input
            type="text"
            placeholder="Enter Student ID"
            value={studentId}
            onChange={(e) => setStudentId(e.target.value)}
          />
          <button onClick={getStudentResult}>Get Student Result</button>
          {studentResult && (
            <div>
              <p>Name: {studentResult.name}</p>
              <p>Score: {studentResult.score}</p>
              <p>Graded: {studentResult.graded ? "Yes" : "No"}</p>
            </div>
          )}
        </div>

        {/* Deposit and withdraw buttons */}
        <button onClick={deposit}>Deposit 1 ETH</button>
        <button onClick={withdraw}>Withdraw 1 ETH</button>
        <p>User Account Address: {account}</p>
      </div>
    );
  };

  useEffect(() => {
    getWallet();
  }, []);

  return (
    <main className="container">
      <header><h1>Online Exam Result</h1></header>
      {initUser()}
      <style jsx>{`
        .container {
          font-family: 'Roboto', sans-serif; 
          display: flex;
          flex-direction: column;
          align-items: center;
          padding: 20px;
          max-width: 800px;
          margin: 0 auto; 
          background-color: #f4f4f4; 
          border-radius: 8px;
          box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); 
        }

        h1 {
          color: #2196f3; 
          margin-bottom: 20px;
        }

        div {
          margin-bottom: 20px;
          text-align: left;
          width: 100%;
          max-width: 400px;
        }

        label {
          display: block;
          margin-bottom: 5px;
          font-weight: bold;
        }

        input[type="text"] {
          width: calc(100% - 12px);
          padding: 10px;
          margin-bottom: 10px;
          border: 1px solid #ccc;
          border-radius: 4px;
          box-sizing: border-box;
        }

        button {
          background-color: #2196f3; 
          color: white;
          padding: 10px 15px;
          border: none;
          border-radius: 4px;
          cursor: pointer;
          transition: background-color 0.3s ease; 
        }

        button:hover {
          background-color: #1976d2; 
        }

        .result-container {
          border: 1px solid #ccc;
          padding: 15px;
          border-radius: 4px;
          background-color: #fff; 
          box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1); 
        }

        .result-container p {
          margin-bottom: 5px;
        }
      `}</style>
    </main>
  );
}
