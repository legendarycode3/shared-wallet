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






















