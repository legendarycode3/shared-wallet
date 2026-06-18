# Shared Wallet Smart Contract


## 📌 Features
* ****Multi-Owner / Admin-Controlled Wallet Structure:**** Defines a single immutable owner (`i_owner`) who acts as the contract administrator. The owner has exclusive authority to manage permissions and control access. This ensures centralized governance and prevents unauthorized administrative actions. The owner address is permanently fixed at deployment and cannot be modified.
* ****Permission-Based Access Control System:**** Implements a whitelist mechanism using `isPermitted` mapping to track authorized users. Only permitted addresses are allowed to execute restricted functions such as withdrawals. The owner can dynamically grant or revoke permissions. Prevents unauthorized users from interacting with sensitive wallet operations.
* ****Multi-Source ETH Deposit Support:**** Allows the contract to receive ETH through multiple pathways: (i) Explicit deposits via `deposit()` function. (ii) Direct ETH transfers via `receive()` function. (iii) Fallback handling via `fallback()` function. Ensures the wallet can accept funds regardless of transaction format. All deposits emit a `Deposit` event for
 
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
