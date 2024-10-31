# Metacrafters Submission (Eth+Avax Intermediate): Smart Contract Management 

## Exam Results DApp - Project Overview

The **Exam Results DApp** is a decentralized application that enables administrators to manage student records securely on the blockchain. Through this DApp, users can add students, view exam results, and interact with a smart contract to store information on the Ethereum blockchain. This ensures that data is immutable, transparent, and accessible only by those with the necessary permissions.

This project combines a Solidity-based smart contract for backend logic with a React frontend to provide an intuitive interface for users to interact with the blockchain-based exam results system.

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Smart Contract](#smart-contract)
- [Frontend](#frontend)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Technologies Used](#technologies-used)

## Features

- **Add Students:** Admins can add students by specifying a unique name and score, which are then stored on the blockchain.
- **View Student Results:** Anyone can retrieve the result of a specific student by providing their unique ID.
- **Deposit & Withdraw Funds:** Admins can deposit and withdraw Ether from the contract to manage funds associated with this application.

## Smart Contract

The smart contract is written in **Solidity** and deployed on a local Ethereum environment. It includes functionality for adding and managing student results. Each student has an ID, name, and score stored on the blockchain.

### Contract Functions

1. **addStudent(string name, uint256 score)**: Allows the admin to add a student with a given name and score. The function ensures that each student has a unique identifier.
2. **getStudentResult(uint256 id)**: Takes a student’s ID as input and returns their name, score, and grading status.
3. **addRecord(uint256 id, uint256 score)**: Allows an admin to add an exam score for a given student.
4. **deposit()**: Allows the contract owner to deposit funds to the contract for management.
5. **withdraw(uint256 amount)**: Enables the admin to withdraw funds from the contract.

This contract is deployed on the local blockchain at address `0x5FbDB2315678afecb367f032d93F642f64180aa3`. Note that addresses may vary depending on deployment environments.

## Frontend

The frontend is developed using **React** and **ethers.js** to allow seamless interaction with the blockchain and smart contract. 

### Key Components

- **Wallet Connection**: Connects to the user’s MetaMask wallet for contract interaction.
- **Balance Display**: Shows the current Ether balance in the contract.
- **Student Management**: Allows adding a student with a name and score and retrieving results by student ID.
- **Deposit & Withdraw**: Enables fund deposits to and withdrawals from the contract.

### Styling

The frontend has been styled to ensure a user-friendly experience, including input fields for names, IDs, and scores, and functional buttons to interact with the smart contract.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- **Node.js** and **npm** installed on your development environment.
- **MetaMask** browser extension installed for interacting with the blockchain.
- **Ethereum Development Environment** (e.g., Hardhat or Ganache).

## Installation

1. **Clone the Repository**
    ```bash
    git clone https://github.com/yourusername/exam-results-dapp.git
    cd exam-results-dapp
    ```

2. **Install Dependencies**
    ```bash
    npm install
    ```

3. **Compile the Smart Contract**
    Navigate to the contract directory and compile the Solidity contract:
    ```bash
    npx hardhat compile
    ```

4. **Deploy the Smart Contract**
    Deploy the contract to your local Ethereum environment:
    ```bash
    npx hardhat node
    npx hardhat run scripts/deploy.js --network localhost
    ```

5. **Update Contract Address in Frontend**
   Replace the contract address in `HomePage.js` with the address obtained after deployment.

## Usage

1. **Run the Frontend Application**
    ```bash
    npm start
    ```

2. **Open MetaMask and Connect**
   Ensure MetaMask is connected to your local Ethereum environment.

3. **Interact with the DApp**
    - **Add Students**: Input the student's name and score and click "Add Student."
    - **Get Results**: Enter the student ID to retrieve their result.
    - **Deposit/Withdraw Funds**: Click "Deposit" or "Withdraw" to manage contract funds.

## Technologies Used

- **Solidity**: For writing the smart contract.
- **Hardhat**: Ethereum development environment.
- **React**: Frontend framework for building the user interface.
- **Ethers.js**: Library for interacting with the Ethereum blockchain.
- **MetaMask**: Wallet extension for connecting to the blockchain.
