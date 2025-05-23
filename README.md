

# sBTC-Votary Governance Smart Contract

## Overview

**sBTC-Votary** is a governance smart contract written in Clarity for the Stacks blockchain. It enables a decentralized community to **create**, **vote**, **update**, **cancel**, and **execute** proposals. This governance system is designed for DAOs, community-led projects, and decentralized applications that require transparent and trustless decision-making processes.

---

## 📜 Features

* **Proposal Creation**: Community members can submit new proposals with custom voting durations.
* **Voting System**: Users vote `for` or `against` proposals within the open voting window.
* **Proposal Execution**: Passed proposals can be executed automatically when voting ends.
* **Proposal Cancellation**: Creators can cancel their proposals before voting ends.
* **Voting Duration Update**: Creators can extend or modify the duration of active proposals.

---

## 🚀 Getting Started

### Requirements

* [Clarity Language SDK](https://docs.stacks.co/write-smart-contracts)
* [Clarinet](https://github.com/hirosystems/clarinet) (for local development and testing)

### Deployment

1. Clone the repo:

   ```bash
   git clone https://github.com/yourusername/sBTC-Votary.git
   cd sBTC-Votary
   ```

2. Build the contract with Clarinet:

   ```bash
   clarinet check
   ```

3. Deploy to Stacks Testnet/Mainnet using the appropriate tooling (e.g., Clarinet or Hiro Wallet).

---

## 🧠 Contract Design

### Constants

| Constant          | Purpose                                 |
| ----------------- | --------------------------------------- |
| `contract-owner`  | Stores the address of contract deployer |
| `err-*` constants | Standardized error codes for clarity    |

### Data Structures

* **proposals (map)**
  Stores all proposal metadata and voting stats.

* **voter-votes (map)**
  Tracks whether a principal has voted on a given proposal.

* **next-proposal-id (var)**
  Counter for assigning unique proposal IDs.

### Key Functions

#### Public

| Function                 | Description                                     |
| ------------------------ | ----------------------------------------------- |
| `create-proposal`        | Submits a new proposal                          |
| `vote`                   | Casts a vote for or against a proposal          |
| `cancel-proposal`        | Cancels an active proposal                      |
| `update-voting-duration` | Updates the voting window of an active proposal |
| `execute-proposal`       | Executes a proposal if voting passes            |

#### Read-Only

| Function               | Description                                           |
| ---------------------- | ----------------------------------------------------- |
| `get-proposal-details` | Returns metadata and vote counts for a given proposal |

---

## 📋 Proposal Lifecycle

1. **Creation** → Creator submits a description and duration.
2. **Voting** → Community votes within the specified timeframe.
3. **Execution** → Proposal is passed if majority votes `for`.
4. **Final State** → Proposal is marked as `executed`, `cancelled`, or remains `inactive`.

---

## 🧪 Example Test Cases

* Proposal creation with zero duration → ❌ Rejected.
* Voting after the voting window closes → ❌ Rejected.
* Double voting → ❌ Rejected.
* Successful proposal with more `for` than `against` → ✅ Executed.

---

## ❗ Error Codes

| Code   | Description                     |
| ------ | ------------------------------- |
| `u100` | Not contract owner              |
| `u101` | Proposal not found              |
| `u102` | Already voted                   |
| `u103` | Voting closed                   |
| `u104` | Insufficient votes to pass      |
| `u105` | Not proposal creator            |
| `u106` | Proposal already cancelled      |
| `u107` | Invalid voting duration         |
| `u108` | Cannot modify a closed proposal |
| `u109` | Invalid proposal ID             |
| `u110` | Description exceeds max length  |

---
