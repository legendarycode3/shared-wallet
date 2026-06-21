# Shared Wallet Smart Contract


## 📌 Features
* ****Event-Based Transaction Transparency:**** Implements event logging for all major state changes: (i) `Deposit` emitted when ETH is received. (ii) `Withdrawal` emitted when funds are sent out. (iii) `AddressPermitted` emitted when user permissions are updated. (iv) `AllowanceUpdated` emitted when spending limits change. It Provides full on-chain traceability for frontends and analytics tools.
* ****Multi-Owner / Admin-Controlled Wallet Structure:**** Defines a single immutable owner (`i_owner`) who acts as the contract administrator. The owner has exclusive authority to manage permissions and control access. This ensures centralized governance and prevents unauthorized administrative actions. The owner address is permanently fixed at deployment and cannot be modified.
* ****Permission-Based Access Control System:**** Implements a whitelist mechanism using `isPermitted` mapping to track authorized users. Only permitted addresses are allowed to execute restricted functions such as withdrawals. The owner can dynamically grant or revoke permissions. Prevents unauthorized users from interacting with sensitive wallet operations.
* ****Multi-Source ETH Deposit Support:**** Allows the contract to receive ETH through multiple pathways: (i) Explicit deposits via `deposit()` function. (ii) Direct ETH transfers via `receive()` function. (iii) Fallback handling via `fallback()` function. Ensures the wallet can accept funds regardless of transaction format. All deposits emit a `Deposit` event for transparency and tracking.
* ****Automatic ETH Reception Handling:**** Uses Solidity’s `receive()` and `fallback()` functions to automatically accept ETH transfers without requiring function calls. This ensures compatibility with wallets, exchanges, and external contracts that send ETH directly to the contract address. 
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



## Getting Started
### Prerequisites




## Why This Matters (Shared Wallet Smart Contract)
* ****Eliminates Single Points of Failure:**** In a traditional wallet, a single private key controls all funds. If that key is lost, stolen, forgotten, or compromised, the assets are at risk. A Shared Wallet distributes operational authority across multiple authorized participants. Even if one participant loses access to their wallet or becomes unavailable, the treasury can continue functioning through other authorized members, reducing dependence on a single individual.
* ****Enables Collaborative Fund Management:**** Most organizations are not run by one person. Businesses, DAOs, nonprofits, project teams, and investment groups often need multiple people to interact with shared funds. A Shared Wallet allows several participants to contribute to and manage a common treasury while maintaining clear rules about who can spend funds and under what conditions.
* ****Enforces Spending Limits Automatically:**** In a traditional setup, managers may have access to company funds with only policy documents restricting their spending. A Shared Wallet can enforce spending limits directly in code through allowances. Instead of relying on trust or manual oversight, the blockchain automatically prevents a user from spending more than their authorized amount.
* ****Reduces Insider Threats:**** One of the greatest risks to organizational funds comes from trusted insiders. Employees, partners, or managers with unrestricted access can intentionally or accidentally misuse funds. A Shared Wallet minimizes this risk by restricting access and limiting withdrawal amounts. Even if an authorized account is compromised or behaves maliciously, the potential damage is constrained by the permissions and allowances assigned to that account.
* ****Replaces Trust with Verifiable Rules:**** Traditional financial systems often depend on trusting individuals to follow policies and procedures. A Shared Wallet replaces human promises with executable code. The rules governing who can withdraw funds, how much they can withdraw, and under what circumstances are transparently encoded in the smart contract and enforced by the blockchain.
* ****Creates Transparent Financial Operations:**** Every deposit, withdrawal, permission update, and allowance adjustment can be permanently recorded on-chain through events and transaction history. This creates a transparent and immutable audit trail that stakeholders can verify independently.
* ****Supports Organizational Growth:**** As organizations expand, financial responsibilities become more complex. What works for a single founder becomes inefficient when multiple departments, managers, contractors, and stakeholders need access to funds. A Shared Wallet scales naturally by allowing permissions and spending limits to be assigned to different participants based on their roles and responsibilities.
* ****Prevents Unauthorized Withdrawals:**** Unlike a standard wallet where possession of the private key grants complete control, a Shared Wallet introduces authorization checks before funds can be moved. Users must satisfy the contract's permission requirements before any withdrawal is executed. Unauthorized accounts are automatically rejected by the contract regardless of their intentions.
* ****Provides Continuous Access to Treasury Funds:**** Traditional financial systems often depend on banking hours, approval chains, or specific personnel being available. A Shared Wallet operates 24/7 on the blockchain. Authorized users can interact with the treasury whenever necessary, enabling faster operations and reducing delays caused by administrative bottlenecks.
* ****Creates Built-In Budget Controls:**** Organizations frequently establish budgets but struggle to enforce them consistently. A Shared Wallet can encode those budgets directly into the treasury system.
* ****Improves Security Through Least-Privilege Access:**** Security experts recommend granting users only the permissions necessary to perform their responsibilities. A Shared Wallet implements this principle by allowing administrators to assign limited access rather than full treasury control.
* ****Creates an Immutable Audit Trail:****  Every action performed through the contract becomes part of the blockchain's permanent history. Unlike spreadsheets, bank records, or internal databases that can be modified, blockchain records are immutable and publicly verifiable.
* ****Enables Shared Ownership of Assets:**** Many digital assets belong to groups rather than individuals. Examples include startup treasuries, DAO funds, family investment pools, and community grants. A Shared Wallet provides a framework for managing collectively owned assets requiring one person to hold complete control over the funds.
* ****Reduces Human Error:**** Human mistakes are responsible for many financial losses. A Shared Wallet automatically validates conditions before executing transactions, helping prevent errors 
* ****Serves as a Foundation for Advanced Treasury Systems:****  A Shared Wallet is often the first step toward more sophisticated treasury management solutions. Features such as multi-signature approvals, DAO voting, time-locked withdrawals, , automated payroll, recurring payments, and governance mechanisms can all be built on top of the shared wallet model.
* ****Increases Accountability Among Team Members:****  When every transaction is visible and attributable to a specific address, participants become more accountable for their actions. Users know that all withdrawals and treasury interactions are permanently recorded, encouraging responsible financial behavior and discouraging misuse of funds.
* ****Enables Decentralized Financial Coordination:**** A Shared Wallet allows geographically distributed teams to coordinate financial activities without relying on traditional banks or centralized financial institutions. Team members can contribute, manage, and access funds from anywhere in the world while operating under the same transparent set of blockchain-enforced rules.



## Key Benefits of Shared Wallet Contracts
* ****Improves Treasury Security Through Multi-Party Authorization:****  A Shared Wallet can require multiple approvals before funds are transferred. This additional security layer prevents unauthorized withdrawals, reduces the impact of compromised accounts, and protects treasury assets from malicious actors. Even if one participant's wallet is hacked, an attacker cannot access the funds without obtaining the required number of approvals from other authorized members.
* ****Enables Collective Decision-Making:**** Shared Wallets allow multiple stakeholders to participate in treasury management and fund allocation decisions. Rather than placing financial authority in the hands of a single individual, the wallet can require approvals from designated members before transactions are executed. This promotes democratic governance, minimizes unilateral actions, and ensures that major financial decisions reflect group consensus.
* ****Enhances Transparency and Accountability:**** Every deposit, withdrawal, approval, rejection, and wallet interaction is permanently recorded on the blockchain. This creates a transparent and auditable financial history that all stakeholders can independently verify. Teams, DAOs, businesses, and investment groups benefit from increased trust because no participant can secretly move funds without creating an immutable on-chain record.
* ****Eliminates Single Points of Failure:**** A Shared Wallet distributes control of funds across multiple participants rather than relying on a single private key holder. This significantly reduces the risk of fund loss due to compromised credentials, insider threats, human error, or the sudden unavailability of a single administrator. By decentralizing authority, organizations can ensure continuity of operations even if one participant loses access to their wallet or leaves the organization.
* ****Facilitates Collaborative Fund Management:**** Shared Wallets are ideal for organizations, DAOs, startups, investment syndicates, families, and community groups that collectively manage capital. Contributors can pool resources into a single treasury while maintaining visibility and participation in fund management. This simplifies coordination and ensures that all members operate from a unified financial system.
* ****Provides Immutable Audit Trails:****  Every transaction and approval event is permanently stored on-chain, creating a tamper-proof audit trail. This feature is particularly valuable for compliance, governance, financial reporting, and dispute resolution. Auditors, investors, regulators, and community members can independently verify treasury activities without relying on centralized records or third-party reports.
* ****Reduces Internal Fraud and Misuse of Funds:**** By requiring multiple participants to approve transactions, Shared Wallets make it significantly more difficult for a single individual to misappropriate treasury assets. The need for collective authorization creates checks and balances that discourage fraudulent behavior and increase confidence among stakeholders managing shared resources.
* ****Supports Flexible Governance Structures:**** Shared Wallet Smart Contracts can be customized to reflect various governance models. Organizations can define voting thresholds, approval requirements, spending limits, emergency procedures, role hierarchies, and permission levels. This flexibility allows the wallet to adapt to the operational needs of DAOs, enterprises, nonprofits, and decentralized communities.
* ****Enables Automated Treasury Operations:**** Smart contract logic can automate treasury management processes that would otherwise require manual oversight. Examples include recurring payments, contributor rewards, salary distributions, grant funding, profit sharing, subscription payments, and milestone-based disbursements. Automation improves efficiency while reducing administrative workload and human error.
* ****Strengthens Trust Among Stakeholders:**** Trust is often a major challenge when multiple parties manage shared funds. A Shared Wallet replaces trust in individuals with trust in transparent smart contract rules. Participants can verify wallet balances, transaction history, and governance requirements directly on-chain, reducing the need for intermediaries and increasing confidence in treasury operations.
* ****Simplifies DAO Treasury Management:**** For decentralized organizations, Shared Wallets serve as the backbone of treasury management. Community funds can be secured, governed, and distributed according to predefined rules that align with DAO governance mechanisms. This ensures that treasury decisions are executed transparently and in accordance with community-approved proposals.
* ****Supports Role-Based Access Control:**** A Shared Wallet can assign different responsibilities to different participants. For example, some members may have proposal creation rights, others may act as approvers, while administrators manage membership and permissions. This separation of duties improves operational efficiency and reduces security risks associated with excessive privileges.
* ****Improves Operational Continuity:**** Organizations often face disruptions when key personnel leave, become unavailable, or lose access credentials. Shared Wallets ensure treasury operations continue because control is distributed among multiple authorized participants. This reduces dependency on any single individual and enhances organizational resilience.
* ****Enables Scalable Financial Governance:**** As organizations grow, managing treasury funds becomes increasingly complex. Shared Wallets provide a scalable framework for handling larger treasuries, additional stakeholders, and more sophisticated governance requirements. New members, approval layers, and treasury policies can be integrated without fundamentally changing the wallet's architecture.
* ****Serves as a Foundation for Advanced Treasury Systems:**** A Shared Wallet is often the first step toward more sophisticated treasury management solutions. Features such as multi-signature approvals, DAO voting,  time-locked withdrawals, spending limits, automated payroll, recurring payments, grant distribution systems,
* ****Enables Programmable Financial Policies:**** Unlike traditional bank accounts, Shared Wallets can enforce rules directly through smart contract code. Organizations can define spending caps, withdrawal cooldown periods, approval thresholds based on transaction size, budget allocations, and treasury restrictions. These policies execute automatically, ensuring financial discipline without requiring constant manual oversight.
* ****Reduces Reliance on Trusted Third Parties:**** Traditional shared financial management often depends on banks, custodians, accountants, or intermediaries to enforce controls and manage access. Shared Wallet Smart Contracts replace many of these functions with transparent code, reducing operational costs, minimizing intermediary risks, and giving participants direct control over treasury assets.
* ****Facilitates Global Collaboration Without Borders:**** Participants from different countries can securely manage a shared treasury without requiring access to the same banking system or jurisdiction. Shared Wallets enable borderless collaboration, making them particularly valuable for international DAOs, remote teams, global investment clubs, and open-source communities operating across multiple regions.
* ****Increases Investor and Community Confidence:**** For projects that manage community funds, grants, or investor capital, Shared Wallets demonstrate a commitment to transparency and responsible treasury management. Visible governance processes and auditable transactions help build credibility, attract contributors, and reassure stakeholders that funds are being managed according to agreed-upon rules.
* ****Creates a Verifiable Source of Financial Truth:**** A Shared Wallet acts as a single, authoritative source of treasury information. Since balances, approvals, and transaction histories are recorded on-chain, all participants work from the same dataset. This eliminates disputes arising from conflicting records and provides real-time visibility into the organization's financial position.
     

  
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
