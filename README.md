# Shared Wallet Smart Contract


## 📌 Features
* ****Multi-Owner / Admin-Controlled Wallet Structure:**** Defines a single immutable owner (`i_owner`) who acts as the contract administrator. The owner has exclusive authority to manage permissions and control access. This ensures centralized governance and prevents unauthorized administrative actions. The owner address is permanently fixed at deployment and cannot be modified.
* ****Permission-Based Access Control System:**** Implements a whitelist mechanism using `isPermitted` mapping to track authorized users. Only permitted addresses are allowed to execute restricted functions such as withdrawals. The owner can dynamically grant or revoke permissions. Prevents unauthorized users from interacting with sensitive wallet operations.
* ****Multi-Source ETH Deposit Support:**** Allows the contract to receive ETH through multiple pathways: (i) Explicit deposits via `deposit()` function. (ii) Direct ETH transfers via `receive()` function. (iii) Fallback handling via `fallback()` function. Ensures the wallet can accept funds regardless of transaction format. All deposits emit a `Deposit` event for transparency and tracking.
* ****Automatic ETH Reception Handling:**** Uses Solidity’s `receive()` and `fallback()` functions to automatically accept ETH transfers without requiring function calls. This ensures compatibility with wallets, exchanges, and external contracts that send ETH directly to the contract address. 
* ****Event-Based Transaction Transparency:**** Implements event logging for all major state changes: (i) `Deposit` emitted when ETH is received. (ii) `Withdrawal` emitted when funds are sent out. (iii) `AddressPermitted` emitted when user permissions are updated. (iv) `AllowanceUpdated` emitted when spending limits change. It Provides full on-chain traceability for frontends and analytics tools.
* ****Per-User Allowance / Spending Limit System**** Introduces a custom allowance model using `allowance` mapping. Each permitted user has a predefined withdrawal limit that restricts how much they can withdraw from the contract. This adds a budgeting layer on top of permission control, preventing unlimited fund access even for authorized users.
* ****Controlled Withdrawal Mechanism:**** Implements a secure withdrawal system that enforces multiple checks: (i) User must be marked as permitted.  (ii) Contract must have sufficient ETH balance.  (iii) User must not exceed their allowance.  Allowance is reduced before transfer execution to prevent reentrancy exploits. Ensures funds are only released under strict validation rules.
* ****Reentrancy Attack Protection:**** Uses OpenZeppelin’s `ReentrancyGuard` to prevent recursive withdrawal attacks. The `nonReentrant` modifier ensures that no nested withdrawal calls can occur during an active transaction, protecting user funds from exploitation via malicious fallback contracts.
* ****Strict Balance Validation System:**** Before executing withdrawals, the contract verifies that it holds enough ETH to fulfill the request. If the balance is insufficient, the transaction is reverted with a custom error. This prevents overdrafts and ensures safe fund accounting.
* ****Zero Address Validation Safety Layer:**** Prevents assignment of invalid addresses (`address(0)`) in sensitive functions such as permission and allowance updates. This avoids accidental fund locking or misconfiguration caused by invalid Ethereum addresses.
* ****Secure Low-Level ETH Transfers:**** Uses low-level `.call{value: amount}("")` for ETH transfers instead of deprecated `transfer()` or `send()`. This ensures compatibility with contracts requiring higher gas limits while still validating transfer success explicitly.
* ****Custom Error Optimization System:**** Replaces traditional `require()` strings with custom Solidity errors for gas efficiency and clarity. Reduces gas costs and improves debugging precision.
* ****Contract Balance Query System:**** Provides a read-only function `getBalance()` to retrieve the total ETH held by the contract. Enables external applications, dashboards, and users to monitor wallet liquidity without modifying state.
* ****Transparent Administrative Control System:**** All administrative actions (permissions and allowances) emit events, ensuring that changes to user rights and spending limits are fully observable on-chain.
* ****Secure State Mutation Ordering(Anti-Reentrancy Design Pattern):**** Follows the “checks-effects-interactions” pattern: (i) Validate permissions and balances.  (ii) Deduct allowance (state change first).  (iii) Execute external ETH transfer. Utilized the pattern to  Reduces attack surface for reentrancy and inconsistent state updates.


## 🧠 Key Concepts Applied
* ****Ownership & Access Control:**** Uses an `owner-based authorization` model. The deployer is stored as an immutable owner.
* ****Role-Based Permissions:**** Implements a permission system using a mapping. Only permitted addresses can withdraw funds. Permissions can be granted or revoked dynamically.
* ****Custom Modifiers:**** Uses modifiers to avoid code repetition. It Enforces authorization before function execution.
* ****State Variables:**** Stores persistent blockchain data: `Owner address`, `Permission records`, `User allowances`.
* ****Immutable Variables:**** The owner is declared as `immutable` value. It is Gas-efficient and used because it is set once during deployment and never changes.
* ****Mappings:**** Uses mappings for efficient key-value storage. Provides O(1) lookups for permissions and allowances.
* ****Allowance-Based Spending Model:**** Similar to the allowance concept in ERC-20 tokens. Users can only withdraw up to their assigned allowance.
* ****Ether Handling Mechanisms:**** The contract implements all The contract accepts Ether through: (i) Deposit Function. (ii) Receive Function. (iii) Fallback Function. This allows Ether deposits through `Direct transfers`, `Explicit deposit calls`, `Unknown function calls with ETH attached`.

* ****Events for Logging:**** Events are emitted whenever important actions occur. Events provide an on-chain audit trail. Implemented for Transaction tracking, Gas-efficient record keeping.
* ****Custom Errors:**** Uses Solidity custom errors instead of revert strings. For the benefit of Lower gas costs, more structured error information.
* ****Reentrancy Protection:**** Inherits from OpenZeppelin's `ReentrancyGuard` and protects withdrawals with: `nonReentrant`. This prevents classic reentrancy attacks where a malicious contract repeatedly re-enters the withdrawal function before state updates complete.
* ****Checks-Effects-Interactions Pattern:**** Implemented on the contract functions, one of which is the `withdrawal` function. The pattern helps reduces reentrancy risk.
* ****Low-Level Calls:**** Ether transfers are performed .
* ****Constructor:**** The constructor , sets the owner, grants initial permission to the deployer.
* ****View Functions:**** Implemented a read-only function for `getBalance` function. It does not modify state, and costs no gas when called off-chain.
* ****Defensive Programming(Validation):**** The contract validates inputs and state before execution for `Zero address checks`, `Balance checks`, `Allowance checks`.
* ****Permitted Modifier:**** Ensures only approved users can withdraw. 



## 📂 Project Structure (Files)



## 🌐Technology Stack (Technologies Used)



## Why This Matters (Shared Wallet Smart Contract)
* ****Eliminates Single Points of Failure:**** In a traditional wallet, a single private key controls all funds. If that key is lost, stolen, forgotten, or compromised, the assets are at risk. A Shared Wallet distributes operational authority across multiple authorized participants. Even if one participant loses access to their wallet or becomes unavailable, the treasury can continue functioning through other authorized members, reducing dependence on a single individual.
* ****Enables Collaborative Fund Management:**** Most organizations are not run by one person. Businesses, DAOs, nonprofits, project teams, and investment groups often need multiple people to interact with shared funds. A Shared Wallet allows several participants to contribute to and manage a common treasury while maintaining clear rules about who can spend funds and under what conditions.
* ****Enforces Spending Limits Automatically:**** In a traditional setup, managers may have access to company funds with only policy documents restricting their spending. A Shared Wallet can enforce spending limits directly in code through allowances. Instead of relying on trust or manual oversight, the blockchain automatically prevents a user from spending more than their authorized amount.
* ****Reduces Insider Threats:**** One of the greatest risks to organizational funds comes from trusted insiders. Employees, partners, or managers with unrestricted access can intentionally or accidentally misuse funds. A Shared Wallet minimizes this risk by restricting access and limiting withdrawal amounts. Even if an authorized account is compromised or behaves maliciously, the potential damage is constrained by the permissions and allowances assigned to that account.
* ****Replaces Trust with Verifiable Rules:**** Traditional financial systems often depend on trusting individuals to follow policies and procedures. A Shared Wallet replaces human promises with executable code. The rules governing who can withdraw funds, how much they can withdraw, and under what circumstances are transparently encoded in the smart contract and enforced by the blockchain.
* ****Creates Transparent Financial Operations:**** Every deposit, withdrawal, permission update, and allowance adjustment can be permanently recorded on-chain through events and transaction history. This creates a transparent and immutable audit trail that stakeholders can verify independently.
* ****Supports Organizational Growth:**** As organizations expand, financial responsibilities become more complex. What works for a single founder becomes inefficient when multiple departments, managers, contractors, and stakeholders need access to funds. A Shared Wallet scales naturally by allowing permissions and spending limits to be assigned to 
list the "Key Concepts Applied" using this solidity smart contract 
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";



/**
 * @title   Shared Wallet contract
 * @author  LegendaryCode
 * @notice  Multiple addresses can deposit, but only specific ones can withdraw.
 */
contract SharedWallet is ReentrancyGuard    { 

     /*//////////////////////////////////////////////////////////////
                              STATE VARIABLES 
    //////////////////////////////////////////////////////////////*/
    /**
     * @notice The address of the contract deployer or administrator.
     * @dev This address is set in the constructor and cannot be changed.
    */
    address public immutable i_owner;


    /**
     *  @notice Checks if an address is permitted to execute restricted actions.
     *  @dev Maps an address to its permission status.
     *  @return bool True if the address is permitted, false otherwise.
    */
    mapping (address => bool) public isPermitted;


    /**
     * @notice Maps token owner -> spender -> approved spending amount 
     * @dev ERC-7201 namespaced storage struct
    */
    mapping (address => uint256) public allowance;



    /*//////////////////////////////////////////////////////////////
                              EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted when a user deposits funds into the contract.
    event Deposit(address indexed sender, uint256 amount);

    /// @notice Emitted when a user withdraws funds from the contract.
    event Withdrawal(address indexed to , uint256 amount);

    /// @notice Emitted when an address is granted or revoked permission.
    event AddressPermitted(address indexed user, bool status);

    /// @notice Emitted when a user's allowance is updated
    event AllowanceUpdated(address indexed user, uint256 amount);



     /*//////////////////////////////////////////////////////////////
                              ERRORS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Throws when an unauthorized account attempts to call an owner-only function.
     * @param caller The address that initiated the transaction.
    */
    error Not__Owner(address caller);

    /// @notice Emitted when a caller attempts to execute a restricted function without proper authorization.
    error Caller__NotPermitted();

    /// @notice Thrown when a transfer or payment fails due to inadequate funds.
    error Insufficient__Balance(uint256 available , uint256 required);

    /// @notice Emitted when an external contract call or transfer fails.
    error Transaction__Failed();

    /// @notice Emitted when an operation fails because a zero address(0x00..00) was provided.
    error Address__CannotBeZero();

    /**
     * @notice Emitted when a spender lacks the approved allowance to transfer tokens.
     * @param available The current approved allowance for the spender.
     * @param required The amount of tokens the transaction is attempting to transfer.
    */
    error Insufficient__Allowance(uint256 available, uint256 required);



    /*//////////////////////////////////////////////////////////////
                              MODIFIERS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Restricts function access to the contract owner.
     * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        if(msg.sender != i_owner){
            revert Not__Owner(msg.sender);
        }
        _;
    }

    /*
     * @notice Restricts function execution to permitted accounts only.
     * @dev Checks the `isPermitted` mapping to verify the sender's authorization status.
    */
    modifier onlyPermitted() {
        if(!isPermitted[msg.sender]) {
            revert Caller__NotPermitted();
        }
        _;
    }



     /*//////////////////////////////////////////////////////////////
                              FUNCTIONS 
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Initializes the contract and sets the initial deployer as the owner.
     * @dev Sets the `i_owner` state variable to the address that deploys the contract 
     *      and grants them initial permission in the `isPermitted` mapping.
    */
    constructor() {
        i_owner = msg.sender;

        isPermitted[msg.sender] = true;
    }


    /**
     * @notice Grants or revokes permission for a specified address.
     * @dev Reverts if the provided address is the zero address.
     *      Updates the permission status in the `isPermitted` mapping
     *      and emits an {AddressPermitted} event.
     * @param _user The address whose permission status will be updated.
     * @param _status The permission state to assign:
     *       `true` to grant permission, `false` to revoke permission.
    */
    function setPermission(address _user, bool _status) public onlyOwner {
        if(_user == address(0)){
            revert Address__CannotBeZero();
        }

        isPermitted[_user] = _status;

        emit AddressPermitted(_user, _status);
    }

    
    /**
     * @notice Receives Ether sent directly to the contract and emits a Deposit event.
     * @dev This function triggers automatically when Ether is sent with no data.
    */
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }


    /**
     *  @notice Fallback function to receive Ether and log the deposit.
     *  @dev Executes when the contract receives Ether with no data or 
     *          non-matching function signatures.
     */
    fallback() external payable {
        emit Deposit(msg.sender, msg.value);
    }


    /**
     * @notice Permits users to deposit Ether into the contract.
     * @dev Emits a `Deposit` event containing the sender's address and the amount sent.
     */
    function deposit() public  payable {
         emit Deposit(msg.sender, msg.value);
    }


    /**
     * @notice Sets the allowance amount for a specific user.
     * @dev Reverts if the provided address is the zero address. Updates the 
     *      allowance mapping and emits an `AllowanceUpdated` event.
     * @param _user The address of the user whose allowance is being set.
     * @param _amount The amount of allowance to be granted to the user.
     */
    function setAllowance(address _user, uint256 _amount) public {
        if(_user == address(0)){
            revert Address__CannotBeZero();
        }

        allowance[_user] = _amount;
        emit AllowanceUpdated(_user, _amount);
    }


    /**
     * @notice Withdraws a specified amount of native tokens to the designated recipient.
     * @dev Executes a low-level `call` to transfer Ether after validating the 
     *      contract's balance, the caller's allowance, and applying anti-reentrancy 
     *      modifiers. Emits a `Withdrawal` event upon successful execution.
     * @param _to The destination address to receive the withdrawn funds.
     * @param _amount The exact amount of native tokens (in wei) to withdraw.
    */
    function withdraw(address payable _to, uint256 _amount) public onlyPermitted nonReentrant {

        if(address(this).balance < _amount) {
            revert Insufficient__Balance(address(this).balance, _amount);
        }

        if(allowance[msg.sender] < _amount){
            revert Insufficient__Allowance(allowance[msg.sender], _amount);
        }

        allowance[msg.sender] -= _amount; 
  
        (bool success, ) = _to.call{value: _amount}("");
        if(!success){
            revert Transaction__Failed();
        } 

        emit Withdrawal(_to, _amount);
    }


    /**
     * @notice Retrieves the total Ether balance held by this smart contract.
     * @dev Returns the balance in wei. This function is marked as view and 
     *      does not modify the state of the contract.
     * @return balance The current Ether balance of the contract in uint256.
     */
    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }


}

Key Concepts Applied in the SharedWallet Smart Contract
This contract demonstrates several important Solidity and smart contract development concepts:

1. Ownership & Access Control
Uses an owner-based authorization model.

The deployer is stored as an immutable owner:

address public immutable i_owner;
The onlyOwner modifier restricts sensitive functions:

modifier onlyOwner()
2. Role-Based Permissions
Implements a permission system using a mapping:

mapping(address => bool) public isPermitted;
Only permitted addresses can withdraw funds.

Permissions can be granted or revoked dynamically.

3. Custom Modifiers
Uses modifiers to avoid code repetition:

modifier onlyOwner()
modifier onlyPermitted()
Enforces authorization before function execution.

4. State Variables
Stores persistent blockchain data:

Owner address

Permission records

User allowances

address public immutable i_owner;
mapping(address => bool) public isPermitted;
mapping(address => uint256) public allowance;
5. Immutable Variables
The owner is declared as:

immutable
Gas-efficient because it is set once during deployment and never changes.

6. Mappings
Uses mappings for efficient key-value storage:

mapping(address => bool)
mapping(address => uint256)
Provides O(1) lookups for permissions and allowances.

7. Allowance-Based Spending Model
Similar to the allowance concept in ERC-20 tokens.

Users can only withdraw up to their assigned allowance:

allowance[msg.sender] -= _amount;
8. Ether Handling
The contract accepts Ether through:

Deposit Function
function deposit() public payable
Receive Function
receive() external payable
Fallback Function
fallback() external payable
This allows Ether deposits through:

Direct transfers

Explicit deposit calls

Unknown function calls with ETH attached

9. Events for Logging
Events provide an on-chain audit trail.

event Deposit(...)
event Withdrawal(...)
event AddressPermitted(...)
event AllowanceUpdated(...)
Benefits:

Easier frontend integration

Transaction tracking

Gas-efficient record keeping

10. Custom Errors
Uses Solidity custom errors instead of revert strings:

error Not__Owner(address caller);
error Caller__NotPermitted();
error Insufficient__Balance(uint256 available, uint256 required);
Benefits:

Lower gas costs

More structured error information

11. Reentrancy Protection
Inherits from OpenZeppelin's:

ReentrancyGuard
And protects withdrawals with:

nonReentrant
This prevents classic reentrancy attacks where a malicious contract repeatedly re-enters the withdrawal function before state updates complete.

12. Checks-Effects-Interactions Pattern
The withdrawal function follows the recommended security pattern:

Checks
if(address(this).balance < _amount)
if(allowance[msg.sender] < _amount)
Effects
allowance[msg.sender] -= _amount;
Interaction
_to.call{value: _amount}("");
This reduces reentrancy risk.

13. Low-Level Calls
Ether transfers are performed using:

(bool success, ) = _to.call{value: _amount}("");
Advantages:

Forwards gas

Compatible with smart contract recipients

Preferred over transfer() and send()

14. Constructor Initialization
The constructor:

Sets the owner.

Grants initial permission to the deployer.

constructor() {
    i_owner = msg.sender;
    isPermitted[msg.sender] = true;
}
15. View Functions
Read-only function:

function getBalance() external view returns(uint256)
Does not modify state.

Costs no gas when called off-chain.

16. Defensive Programming
The contract validates inputs and state before execution:

Zero address checks

if(_user == address(0))
Balance checks

if(address(this).balance < _amount)
Allowance checks

if(allowance[msg.sender] < _amount)
17. Encapsulation Through Modifiers and Errors
Business logic is separated into:

Modifiers → access rules

Errors → failure handling

Functions → core functionality

This improves readability and maintainability.

Solidity Concepts Summary
Category	Concepts Used
Access Control	Owner pattern, Role-based permissions
Storage	State variables, Mappings, Immutable variables
Ether Management	Payable functions, Receive, Fallback
Security	ReentrancyGuard, Checks-Effects-Interactions
Error Handling	Custom Errors, Reverts
Logging	Events
Function Types	Constructor, View Functions
Transfers	Low-level call
Code Reuse	Modifiers
Validation	Input checks, Defensive programming
Design Pattern Used
This contract combines:

Shared Wallet Pattern (multiple depositors, controlled withdrawals)

Allowance-Based Spending Pattern

Role-Based Access Control (RBAC)

Checks-Effects-Interactions Security Pattern

Pull-Permission Withdrawal Model (users withdraw only when authorized and funded via allowance)

One important observation: setAllowance() is currently not restricted by onlyOwner, meaning any address can assign allowances to any user. In a production shared wallet, this function would typically be protected with onlyOwner (or another authorization mechanism) to prevent unauthorized allowance assignment.


indept descriptions

In-Depth Description of Key Concepts Applied in the SharedWallet Contract
1. Ownership Pattern
The contract establishes a single administrator (owner) who has special privileges over the wallet.

address public immutable i_owner;
The owner is assigned during deployment:

constructor() {
    i_owner = msg.sender;
}
Why it is used
Ownership is one of the most common access-control mechanisms in Solidity. It allows sensitive operations to be restricted to a trusted account.

In this contract
The owner can:

Grant permissions

Revoke permissions

function setPermission(address _user, bool _status)
Benefit
Prevents unauthorized users from managing wallet permissions.

2. Immutable Variables
address public immutable i_owner;
An immutable variable:

Is assigned once during deployment.

Cannot be modified afterward.

Is cheaper to read than a normal storage variable.

How it works
During deployment:

i_owner = msg.sender;
After deployment:

i_owner = anotherAddress; // impossible
Benefit
Stronger security

Reduced gas costs

Prevents accidental ownership changes

3. Access Control Through Modifiers
Modifiers allow reusable authorization logic.

Owner Modifier
modifier onlyOwner() {
    if(msg.sender != i_owner){
        revert Not__Owner(msg.sender);
    }
    _;
}
Permitted Modifier
modifier onlyPermitted() {
    if(!isPermitted[msg.sender]){
        revert Caller__NotPermitted();
    }
    _;
}
How it works
When a function uses:

function withdraw(...) public onlyPermitted
The modifier executes first.

Flow:

User calls withdraw()
        ↓
onlyPermitted runs
        ↓
Passes? → Continue
Fails? → Revert
Benefit
Avoids repeating authorization logic throughout the contract.

4. Role-Based Access Control (RBAC)
The contract introduces a second layer of authorization.

Instead of only having an owner, it maintains a list of permitted users.

mapping(address => bool) public isPermitted;
Example
isPermitted[0x123...] = true;
Meaning:

Address → Authorized
Permission Management
setPermission(user, true);
Grants access.

setPermission(user, false);
Revokes access.

Why RBAC Matters
Without RBAC:

Only owner can withdraw
With RBAC:

Owner
│
├── Manager A
├── Manager B
└── Treasurer
Multiple trusted users can operate the wallet.

5. Mappings
Mappings are Solidity's hash tables.

mapping(address => bool) public isPermitted;
and

mapping(address => uint256) public allowance;
Structure
Address
   ↓
Value
Example:

0x111 → true
0x222 → false
Allowance Mapping
0x111 → 5 ETH
0x222 → 10 ETH
Benefits
Constant-time lookup (O(1))

Gas efficient

Ideal for permissions and balances

6. Allowance-Based Spending
The contract implements a spending limit mechanism.

mapping(address => uint256) public allowance;
Each permitted user has a withdrawal quota.

Example
allowance[Alice] = 5 ether;
Alice may withdraw up to 5 ETH.

Withdrawal Process
Before withdrawal:

if(allowance[msg.sender] < _amount)
If sufficient:

allowance[msg.sender] -= _amount;
Example
Initial:

Alice → 10 ETH
Withdraws:

3 ETH
Remaining:

Alice → 7 ETH
Benefit
Prevents permitted users from draining the wallet.

7. Ether Reception Mechanisms
The contract can receive Ether in three ways.

A. Deposit Function
function deposit() public payable
Usage:

wallet.deposit{value: 1 ether}();
B. Receive Function
receive() external payable
Triggered when:

payable(wallet).transfer(1 ether);
No calldata supplied.

C. Fallback Function
fallback() external payable
Triggered when:

Unknown function called

Ether sent with unmatched calldata

Example:

wallet.call(
    abi.encodeWithSignature("unknown()")
);
Benefit
The contract never rejects ETH simply because the sender used a different transfer method.

8. Event Logging
Events create permanent transaction logs.

Deposit Event
event Deposit(address indexed sender, uint256 amount);
Emitted:

emit Deposit(msg.sender, msg.value);
Example Log
Deposit(
  sender: 0xABC,
  amount: 2 ETH
)
Withdrawal Event
event Withdrawal(address indexed to, uint256 amount);
Why Events Matter
Smart contracts cannot easily store historical records.

Events allow:

Frontends to monitor activity

Block explorers to display actions

Analytics tools to index transactions

9. Custom Errors
Instead of:

require(condition, "Not owner");
The contract uses:

error Not__Owner(address caller);
Reverting
revert Not__Owner(msg.sender);
Advantages
Lower Gas
Strings consume more storage.

"Not owner"
must be stored.

Custom errors store only encoded parameters.

Better Debugging
Not__Owner(0x123...)
Provides detailed information.

10. Reentrancy Protection
The contract inherits:

ReentrancyGuard
and uses:

nonReentrant
on withdrawals.

What is Reentrancy?
Imagine:

withdraw()
sends ETH to a malicious contract.

That contract's fallback function executes and calls:

withdraw()
again before the first execution finishes.

Result:

Wallet drained repeatedly
This caused the famous DAO hack.

Protection
function withdraw(...)
    public
    nonReentrant
OpenZeppelin places a lock:

Enter function
      ↓
Lock active
      ↓
Reentry attempt
      ↓
Revert
Benefit
Stops recursive withdrawal attacks.

11. Checks-Effects-Interactions Pattern
A critical Solidity security pattern.

Step 1: Checks
Validate requirements.

if(address(this).balance < _amount)
if(allowance[msg.sender] < _amount)
Step 2: Effects
Update state.

allowance[msg.sender] -= _amount;
Step 3: Interactions
Communicate with external addresses.

_to.call{value: _amount}("");
Why It Matters
Bad order:

Send ETH
Update allowance
An attacker could exploit the gap.

Good order:

Check
Update state
Send ETH
State is already updated before external execution.

12. Low-Level Calls
Ether transfer:

(bool success, ) = _to.call{value: _amount}("");
Why Not transfer()?
Older Solidity:

_to.transfer(_amount);
forwards only 2300 gas.

Modern smart contracts often need more.

Advantages of call()
Forwards available gas

Compatible with smart contracts

Recommended by Solidity documentation

Risk
Can trigger external code.

Hence:

nonReentrant
is required.

13. Defensive Programming
The contract validates inputs before executing logic.

Zero Address Validation
if(_user == address(0))
Prevents:

0x0000000000000000000000000000000000000000
from receiving permissions.

Balance Validation
if(address(this).balance < _amount)
Prevents overdrawing funds.

Allowance Validation
if(allowance[msg.sender] < _amount)
Prevents overspending.

Benefit
Makes the contract more robust and resistant to misuse.

14. Separation of Concerns
The contract is organized into logical sections:

State Variables
↓
Events
↓
Errors
↓
Modifiers
↓
Functions
Each component has a single responsibility:

Component	Responsibility
State Variables	Store data
Events	Log actions
Errors	Handle failures
Modifiers	Enforce rules
Functions	Execute business logic
This improves readability, maintainability, and auditability.

15. Shared Wallet Design Pattern
The overall architecture implements a Shared Wallet.

Participants
Depositors
     ↓
Shared Wallet
     ↓
Permitted Users
Anyone can:

Deposit ETH
Only authorized users can:

Withdraw ETH
Additional Control Layer
The allowance system introduces spending limits:

Wallet Balance = 100 ETH

Alice Allowance = 10 ETH
Bob Allowance = 20 ETH
Even though the wallet contains 100 ETH:

Alice cannot withdraw more than 10 ETH.

Bob cannot withdraw more than 20 ETH.

This creates a secure treasury-like structure suitable for:

DAOs

Family funds

Team treasuries

Business operational wallets

Project escrow systems

Security Observation
There is a critical access-control issue:

function setAllowance(address _user, uint256 _amount) public
This function is public and unrestricted.

Any address can execute:

setAllowance(attacker, 1000 ether);
and grant themselves an allowance.

A secure implementation should typically be:

function setAllowance(
    address _user,
    uint256 _amount
) public onlyOwner
Without that restriction, the allowance mechanism can be manipulated by any user, weakening the intended security model.


List Why  "Shared Smart Contract" Matters , with indept description , E.G "Eliminates Single Points of Failure: In a standard wallet, if your private key is lost or compromised by a hacker, your funds are gone. With a MultiSig wallet, an attacker must compromise multiple specific devices or keys to access the assets."

Why a Shared Wallet Smart Contract Matters
A Shared Wallet smart contract is designed to allow multiple people or entities to interact with a common pool of funds while enforcing predefined rules on who can access, manage, and spend those funds. Unlike a traditional wallet controlled by a single private key, a shared wallet introduces governance, accountability, and programmable financial controls.

1. Eliminates Single Points of Failure
In a traditional cryptocurrency wallet, one private key controls all assets. If that key is lost, stolen, or compromised, the funds may become permanently inaccessible or be stolen.

A Shared Wallet distributes operational control across multiple authorized participants.

Traditional Wallet
One Key
   ↓
All Funds
Shared Wallet
Owner
   ↓
Assigns Permissions
   ↓
Multiple Authorized Users
Why This Matters
Suppose a startup stores 100 ETH in a company wallet.

If only the CEO controls the wallet:

CEO loses their private key → funds may be inaccessible.

CEO's device gets hacked → funds may be stolen.

CEO becomes unavailable → company operations halt.

With a Shared Wallet:

Multiple trusted personnel can be authorized.

Operations continue even if one participant becomes unavailable.

Access is not dependent on a single individual.

This significantly improves operational resilience.

2. Enables Team-Based Treasury Management
Many organizations operate collectively rather than individually.

Examples include:

Startups

DAOs

Nonprofits

Investment groups

Family offices

Community projects

A Shared Wallet allows multiple participants to manage funds under a common set of rules.

Example
Project Treasury
      │
 ┌────┼────┐
 │    │    │
Alice Bob Charlie
All members can contribute funds, while only authorized members can spend them.

Why This Matters
Without a Shared Wallet:

One person becomes the financial gatekeeper.

Every transaction depends on that individual.

Financial operations become a bottleneck.

With a Shared Wallet:

Responsibilities can be distributed.

Teams operate more efficiently.

Financial processes become collaborative.

3. Provides Controlled Delegation of Spending Power
One of the most valuable features of your contract is the allowance system.

Instead of giving unrestricted access to treasury funds, specific spending limits can be assigned.

Example
Treasury Balance:

100 ETH
Allowances:

Operations Manager → 10 ETH
Marketing Lead     → 5 ETH
Developer Lead     → 15 ETH
Even though the treasury contains 100 ETH:

Marketing cannot spend 20 ETH.

Operations cannot spend 50 ETH.

Why This Matters
Organizations often need employees to make payments without granting full control of company funds.

The allowance system creates a financial hierarchy that mirrors real-world budgeting practices.

4. Improves Security Through Principle of Least Privilege
The Principle of Least Privilege states that users should only receive the minimum permissions necessary to perform their jobs.

Bad Design
Everyone has unlimited access.
Better Design
User A → 2 ETH allowance
User B → 5 ETH allowance
User C → 10 ETH allowance
Why This Matters
If one authorized account is compromised:

The attacker can only access that account's allowance.

The entire treasury remains protected.

This limits potential damage and reduces organizational risk.

5. Creates Transparent Financial Activity
Every deposit and withdrawal is permanently recorded on-chain.

Events such as:

event Deposit(...)
event Withdrawal(...)
create an immutable audit trail.

Example
June 1:
Alice deposited 5 ETH

June 5:
Bob withdrew 2 ETH

June 7:
Charlie deposited 3 ETH
Why This Matters
Traditional financial systems often rely on:

Spreadsheets

Internal reports

Bank statements

These records can be altered or disputed.

Blockchain records are:

Public

Verifiable

Immutable

This greatly increases accountability.

6. Reduces Insider Risk
Insider threats are among the most dangerous risks faced by organizations.

Examples:

Rogue employees

Corrupt managers

Disgruntled partners

In a normal wallet:

One insider controls everything.
In a Shared Wallet:

Insider
   ↓
Limited Permission
   ↓
Limited Damage
Why This Matters
An employee with a 2 ETH allowance cannot suddenly drain a treasury containing 500 ETH.

The smart contract enforces restrictions automatically.

No human intervention is required.

7. Removes Reliance on Trust Alone
Traditional financial arrangements often depend heavily on trust.

Example:

"We trust the treasurer."
But trust can fail.

People can:

Make mistakes

Act maliciously

Become unavailable

Smart contracts replace trust with code.

Instead of
Trust Bob not to overspend.
You enforce:

Bob cannot spend more than 5 ETH.
Why This Matters
Rules become mathematically enforced rather than socially enforced.

This creates stronger guarantees.

8. Enables Continuous Fund Availability
Traditional financial systems often depend on:

Banking hours

Office approvals

Human processing

A Shared Wallet operates continuously.

Availability
24 Hours
7 Days
365 Days
Why This Matters
Authorized users can execute transactions whenever needed.

Examples:

Emergency vendor payment

Urgent contractor payment

Time-sensitive project expenses

The treasury remains operational globally.

9. Supports Organizational Growth
As projects grow, financial complexity increases.

A single-person wallet may work for:

1 Founder
But becomes problematic for:

20 Employees
10 Contractors
3 Departments
Shared Wallet Structure
Treasury
    │
 ┌──┼──┐
Ops Marketing Dev
Each group can receive tailored permissions and allowances.

Why This Matters
The system scales with organizational growth.

10. Creates Automatic Budget Enforcement
Organizations often create budgets but struggle to enforce them.

Traditional Budget
Marketing Budget = $5,000
An employee may accidentally exceed that limit.

Smart Contract Budget
Marketing Allowance = 5 ETH
The blockchain simply refuses any excess spending.

Why This Matters
Budget violations become technically impossible rather than merely discouraged.

11. Provides Immutable Governance Rules
Traditional financial permissions can be altered through:

Emails

Verbal instructions

Informal agreements

A smart contract encodes governance rules directly on-chain.

Example
Only permitted users may withdraw.
The blockchain enforces this rule permanently.

Why This Matters
No participant can secretly bypass established controls.

Everyone operates under the same transparent rules.

12. Facilitates Shared Ownership of Digital Assets
Many assets are collectively owned.

Examples:

DAO treasuries

Startup reserves

Investment syndicates

Family inheritance funds

A Shared Wallet provides infrastructure for managing collectively owned capital.

Why This Matters
The wallet becomes a neutral financial layer.

Funds belong to the group rather than a single individual.

13. Enhances Auditability and Compliance
Every transaction leaves a permanent record.

Auditors can verify:

Who deposited?
Who withdrew?
How much?
When?
without relying on internal documents.

Why This Matters
Organizations increasingly require:

Financial transparency

Regulatory reporting

Accountability

Blockchain records simplify these processes.

14. Reduces Human Error
Humans frequently make mistakes.

Examples:

Sending excessive amounts

Approving incorrect transfers

Mismanaging budgets

The smart contract automatically validates:

if(balance < amount)
if(allowance < amount)
Why This Matters
The system prevents many costly mistakes before they occur.

15. Creates a Foundation for Advanced Treasury Systems
A Shared Wallet is often the first step toward a more sophisticated treasury architecture.

Future upgrades may include:

Multi-signature approvals

Time-locked withdrawals

DAO governance voting

Automated payroll

Expense management

Revenue distribution

Vesting schedules

Why This Matters
The shared wallet acts as the foundational building block for decentralized financial management systems.

Core Value Proposition
The fundamental purpose of a Shared Wallet is to transform a cryptocurrency wallet from a single-user storage account into a programmable organizational treasury.

Instead of:

One Person
     ↓
Controls Everything
You get:

Shared Funds
      ↓
Smart Contract Rules
      ↓
Controlled Access
      ↓
Transparent Spending
      ↓
Greater Security
This shift—from trust in individuals to enforcement through code—is what makes shared wallet smart contracts valuable for teams, organizations, and communities managing digital assets together.


List Why  "Shared Smart Contract" Matters , with indept description , E.G of style "Eliminates Single Points of Failure: In a standard wallet, if your private key is lost or compromised by a hacker, your funds are gone. With a MultiSig wallet, an attacker must compromise multiple specific devices or keys to access the assets."

Why a Shared Wallet Smart Contract Matters
1. Eliminates Single Points of Failure
In a traditional wallet, a single private key controls all funds. If that key is lost, stolen, forgotten, or compromised, the assets are at risk. A Shared Wallet distributes operational authority across multiple authorized participants. Even if one participant loses access to their wallet or becomes unavailable, the treasury can continue functioning through other authorized members, reducing dependence on a single individual.

2. Enables Collaborative Fund Management
Most organizations are not run by one person. Businesses, DAOs, nonprofits, project teams, and investment groups often need multiple people to interact with shared funds. A Shared Wallet allows several participants to contribute to and manage a common treasury while maintaining clear rules about who can spend funds and under what conditions.

3. Enforces Spending Limits Automatically
In a traditional setup, managers may have access to company funds with only policy documents restricting their spending. A Shared Wallet can enforce spending limits directly in code through allowances. Instead of relying on trust or manual oversight, the blockchain automatically prevents a user from spending more than their authorized amount.

Example:
A project treasury contains 100 ETH. A marketing manager is assigned a 5 ETH allowance. Even though the treasury holds significantly more funds, the manager cannot withdraw more than 5 ETH because the contract enforces that limit automatically.

4. Reduces Insider Threats
One of the greatest risks to organizational funds comes from trusted insiders. Employees, partners, or managers with unrestricted access can intentionally or accidentally misuse funds. A Shared Wallet minimizes this risk by restricting access and limiting withdrawal amounts. Even if an authorized account is compromised or behaves maliciously, the potential damage is constrained by the permissions and allowances assigned to that account.

5. Replaces Trust with Verifiable Rules
Traditional financial systems often depend on trusting individuals to follow policies and procedures. A Shared Wallet replaces human promises with executable code. The rules governing who can withdraw funds, how much they can withdraw, and under what circumstances are transparently encoded in the smart contract and enforced by the blockchain.

Instead of:

"We trust the treasurer not to overspend."

The contract enforces:

"The treasurer cannot spend more than their approved allowance."

6. Creates Transparent Financial Operations
Every deposit, withdrawal, permission update, and allowance adjustment can be permanently recorded on-chain through events and transaction history. This creates a transparent and immutable audit trail that stakeholders can verify independently.

Benefits include:

Easier auditing

Improved accountability

Reduced disputes

Greater stakeholder confidence

No participant can secretly alter financial records after the fact.

7. Supports Organizational Growth
As organizations expand, financial responsibilities become more complex. What works for a single founder becomes inefficient when multiple departments, managers, contractors, and stakeholders need access to funds. A Shared Wallet scales naturally by allowing permissions and spending limits to be assigned to different participants based
* ****Prevents Unauthorized Withdrawals:****
  


  
## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of (Some include):

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).

## Documentation

https://book.getfoundry.sh/

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```
### Gas Snapshots
```shell
$ forge snapshot
```


## Author
Built with ❤️ by [@legendarycode3](https://github.com/legendarycode3/)  </br>

## Appreciation
If you find this project helpful, please consider linking back to this repository. I `appreciate` your support.
