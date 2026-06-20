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
* ****Enables Collaborative Fund Management:**** Most organizations are not run by one person. Businesses, DAOs, nonprofits, project teams, and investment groups often need multiple



  
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
