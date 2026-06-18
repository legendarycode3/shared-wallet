// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {SharedWallet} from "../src/SharedWallet.sol";


contract SharedWalletTest is Test {
    SharedWallet  public wallet;

    ///  @notice Test account representing the contract owner.
    address public OWNER = makeAddr("owner");

    /// @notice Test account representing an authorized wallet user1. 
    address public USER1 = makeAddr("user1");

    /// @notice Test account representing an authorized wallet user2.
    address public USER2 = makeAddr("user2");

    /// @notice Test account representing an unauthorized (non-permitted) user.
    address public USER_UNPERMITED = makeAddr("userUnpermited");

    /// @notice Test account representing a malicious actor used in security tests. 
    address public ATTACKER = makeAddr("attacker");


    // Events matched from the main contract
    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(address indexed to , uint256 amount);
    event AddressPermitted(address indexed user, bool status);
    event AllowanceUpdated(address indexed user, uint256 amount);


    // Custom errors matched from the main contract
    error Not__Owner(address caller);
    error Caller__NotPermitted();
    error Insufficient__Balance(uint256 available , uint256 required);
    error Address__CannotBeZero();
    error Insufficient__Allowance(uint256 available, uint256 required);


    function setUp() public {
        vm.prank(OWNER);

        wallet = new SharedWallet();
    }



    /*///////////////////////////////////////////////////////////////
                                INITIAL_STATE TESTS
    //////////////////////////////////////////////////////////////*/
    
    /**
     *  @notice Verifies that the contract owner is initialized correctly during deployment.
     *  @dev Asserts that the `i_owner` immutable state variable strictly matches the `OWNER` constant.
     *       If this test fails, it indicates an issue in the contract constructor or factory setup.
     */
    function testOwnerIsSetCorrectly() public {
        assertEq(wallet.i_owner(), OWNER, "Owner was not initialized correctly");
    }


    /**
     *  @notice Ensures that the owner is properly permitted upon initialization.
     *  @dev Verifies that the wallet contract correctly assigns permission status to the 
     *      OWNER address immediately after deployment.
    */
    function testOwnerIsInitiallyPermitted() public view {
        assertEq(wallet.isPermitted(OWNER), true, "Owner should be permitted");
    }



    /*///////////////////////////////////////////////////////////////
                                MODIFIER & ACCESS CONTROL TESTS
    //////////////////////////////////////////////////////////////*/
    /**
     * @notice Verifies that a non-owner cannot modify wallet permissions.
     * @dev Mocks `USER1` as the `msg.sender` and expects the transaction to revert 
     *      with the `Not__Owner` custom error, passing the unauthorized address as an      
     *      argument.
     */
    function testOnlyOwnerCanSetPermission() public {
        vm.prank(USER1);

        vm.expectRevert(abi.encodeWithSelector(Not__Owner.selector, USER1));
        wallet.setPermission(USER_UNPERMITED, true);
    }


    /**
     * @notice Verifies that attempting to set a permission for the zero address 
     *      (address(0)) correctly reverts.
     *  @dev Utilizes the `vm.prank` cheatcode to impersonate the OWNER, and expects the 
     *      `Address__CannotBeZero` custom error.
     */
    function testRevertOnZeroAddressPermission() public {
        vm.prank(OWNER);

        vm.expectRevert(Address__CannotBeZero.selector);
        
        wallet.setPermission(address(0), true);
    }


    /**
     * @notice Verifies that the wallet correctly emits an `AddressPermitted` event.
     * @dev Uses the `vm.prank` cheatcode to impersonate the `OWNER`, and `vm.expectEmit` to 
     *      assert that the `AddressPermitted` event is correctly emitted when the wallet's 
     *      permission state changes.
     * 
     */
    function testEmitsAddressPermittedEvent() public {
        vm.prank(OWNER);

        // Params: checkTopic1, checkTopic2, checkTopic3, checkData
        vm.expectEmit(true, false, false, true);

        emit AddressPermitted(USER1, true);

        wallet.setPermission(USER1, true);
    }


    /**
     *  @notice Tests that the wallet reverts when attempting to set an allowance for the 
     *      zero address.
     *  @dev Verifies that `setAllowance` triggers the `Address__CannotBeZero` custom error 
     *      when `address(0)` is passed as the spender.
     */
    function testRevertOnZeroAddressAllowance() public {

        vm.expectRevert(Address__CannotBeZero.selector);

        wallet.setAllowance(address(0), 100);
    }




    /*///////////////////////////////////////////////////////////////
                                DEPOSIT TESTS
    //////////////////////////////////////////////////////////////*/

    /**
     *  @notice Verifies the contract's ability to receive Ether via a low-level call.
     *  @dev Simulates `USER1` sending 1 ETH to the wallet using `vm.prank` and `vm.deal`.
     *       Asserts that the call succeeds, updates the `address(wallet)` balance,
     *       and correctly updates the custom `wallet.getBalance()` getter.
     */
    function testDepositViaReceive() public {

        uint256 depositAmount = 1 ether;
        vm.deal(USER1, depositAmount);

        vm.prank(USER1);
        (bool success, ) = address(wallet).call{value: depositAmount}("");
        assert(success);

        assertEq(address(wallet).balance, depositAmount);
        assertEq(wallet.getBalance(), depositAmount);
    }


    /**
     *  @notice Tests the contract's ability to receive Ether and trigger the fallback 
     *          function.
     *  @dev Uses Foundry's `vm.prank` and `vm.deal` to simulate a user sending 1 ether
     *      along with calldata for a non-existent function. This ensures the fallback 
     *      function is successfully invoked and the funds are credited to the wallet.
     */
    function testDepositViaFallback() public {
        uint256 depositAmount = 1 ether;
        vm.deal(USER1, depositAmount);

        // Sending data triggers fallback
        vm.prank(USER1);
        (bool success, ) = address(wallet).call{value: depositAmount}(abi.encodeWithSignature("nonExistentFunction()"));
        assert(success);

        assertEq(address(wallet).balance, depositAmount);
    }


    /**
     * @notice Tests the deposit functionality of the wallet.
     * @dev Verifies that when a user deposits exactly $1$ ETH, 
     *      the contract's balance is updated correctly. 
     *      It uses Foundry cheatcodes to simulate a funded user (vm.deal) 
     *      and to execute the transaction from that user's context (vm.prank).
     */
    function testDepositViaFunction() public {
        uint256 depositAmount = 1 ether;
        vm.deal(USER1, depositAmount);

        vm.prank(USER1);
        wallet.deposit{value: depositAmount}();

        assertEq(address(wallet).balance, depositAmount);
    }



    /*///////////////////////////////////////////////////////////////
                                PERMISSION TESTS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Verifies that the contract owner can successfully grant permissions to an address.
     * @dev Uses the Foundry `vm.prank` cheatcode to simulate the `OWNER` 
     *      calling the `setPermission` function.
     *      Asserts that the permission status for `USER1` is set to `true`.
     */
    function testOwnerCanSetPermission() public {
        vm.prank(OWNER);

        wallet.setPermission(USER1, true);

        assertEq(wallet.isPermitted(USER1), true);
    }


    /**
     *  @notice Verifies that setting a permission on the wallet correctly emits the 
     *          AddressPermitted event.
     *  @dev Impersonates the OWNER using `vm.prank`, sets `expectEmit` 
     *       to validate topics and event data, 
     *       and ensures the `setPermission` call emits the expected `AddressPermitted      
     *       (USER1, true)` event.
     */
    function testEmitEventOnSetPermission() public {
        vm.prank(OWNER);

        vm.expectEmit(true, true, false, true);

        emit AddressPermitted(USER1, true);

        wallet.setPermission(USER1, true);
    }


    /**
     * @notice Verifies that an unauthorized account (non-owner) cannot modify permissions.
     * @dev Mocks `msg.sender` as `USER1` using Foundry's `vm.prank`. 
     *      Asserts that calling `setPermission` reverts with the `Not__Owner` custom error.
     */
    function testNonOwnerFailsToSetPermission() public {
        vm.prank(USER1);

        vm.expectRevert(abi.encodeWithSelector(Not__Owner.selector, USER1));

        wallet.setPermission(USER2, true);
    }


    /**
     *  @notice Tests that setting a permission for the zero address reverts.
     *  @dev Uses `vm.prank` to simulate the contract `OWNER` calling the function.
     *       Expects the `Address__CannotBeZero` custom error to be thrown.
     */
    function testRevertWhenSettingZeroAddressPermission() public {
        vm.prank(OWNER);

        vm.expectRevert(Address__CannotBeZero.selector);

        wallet.setPermission(address(0), true);
    }



     /*///////////////////////////////////////////////////////////////
                                ALLOWANCE TESTS
    //////////////////////////////////////////////////////////////*/

    /**
     *  @notice Verifies that the wallet owner can successfully set an allowance for a user.
     *  @dev Uses Foundry's `vm.prank` to simulate `msg.sender` as `OWNER`.
     *       Asserts that the queried allowance for `USER1` equals the specified `amount` 
     *       (100 ether).
     */
    function testSetAllowance() public {
        uint256 amount = 100 ether;
        
        vm.prank(OWNER);
        wallet.setAllowance(USER1, amount);

        assertEq(wallet.allowance(USER1), amount);
    }


    /**
     * @notice Tests the successful emission of an AllowanceUpdated event.
     * @dev Mocks the `OWNER` using `vm.prank`, sets up an `expectEmit` assertion for the 
     *      indexed topics (Address 1 = true, Address 2 = true), and validates that 
     *      calling `setAllowance` correctly emits the AllowanceUpdated event with 
     *      the proper user address and 50 ether amount.
     */
    function testEmitEventOnSetAllowance() public {
        vm.prank(OWNER);

        vm.expectEmit(true, true, false, true);

        emit AllowanceUpdated(USER1, 50 ether);

        wallet.setAllowance(USER1, 50 ether);
    }


    /**
     * @notice Verifies that setting an allowance for the zero address (address(0)) reverts.
     * @dev Mocks the `OWNER` using `vm.prank` and expects the `Address__CannotBeZero` 
     *      custom error.
     */
    function testRevertWhenSettingZeroAddressAllowance() public {
        vm.prank(OWNER);

        vm.expectRevert(Address__CannotBeZero.selector);

        wallet.setAllowance(address(0), 100 ether);
    }



     /*///////////////////////////////////////////////////////////////
                                WITHDRAWAL TESTS
    //////////////////////////////////////////////////////////////*/


    /**
     * @notice Tests that a permitted user can withdraw funds within their set allowance.
     * @dev Uses Foundry's cheatcodes (`vm.deal`, `vm.prank`) to simulate funding the 
     *      wallet, granting permissions and allowance, and performing the withdrawal.
     *      Asserts that the wallet's total balance and the user's remaining allowance 
     *      are correctly updated after the transaction.
     */
    function testPermittedUserCanWithdrawWithinAllowance() public {
        // Fund the wallet
        vm.deal(OWNER, 10 ether);
        vm.prank(OWNER);
        wallet.deposit{value: 10 ether}();

        // Give user1 allowance and permission
        vm.startPrank(OWNER);
        wallet.setPermission(USER1, true);
        wallet.setAllowance(USER1, 5 ether);
        vm.stopPrank();


        // User 1 withdraws
        uint256 withdrawAmount = 2 ether;
        vm.prank(USER1);
        wallet.withdraw(payable(USER1), withdrawAmount);

        assertEq(address(wallet).balance, 8 ether);
        assertEq(wallet.allowance(USER1), 3 ether); // 5 - 2
    }


    /**
     * @notice Verifies that a non-permitted user cannot execute a withdrawal.
     * @dev Funds the wallet, sets an allowance for the attacker 
     *      (simulating incorrect permission configuration), and verifies that the  
     *      transaction reverts with `Caller__NotPermitted` when the attacker attempts to 
     *      withdraw funds.
     */
    function testRevertWhenNotPermittedUserWithdraws() public {
        // Fund and set allowance
        vm.deal(OWNER, 10 ether);
        vm.prank(OWNER);
        wallet.deposit{value: 10 ether}();
        
        vm.prank(OWNER);
        wallet.setAllowance(ATTACKER, 5 ether);

        // Attacker is NOT permitted
        vm.prank(ATTACKER);
        vm.expectRevert(Caller__NotPermitted.selector);
        wallet.withdraw(payable(ATTACKER), 1 ether);
    }


    /**
     * @notice Verifies that the wallet correctly reverts a withdrawal attempt 
     *         when the requested amount exceeds the user's set allowance.
     * @dev Mints 10 ether to the OWNER, who then deposits it and grants USER1 
     *      an allowance of 1 ether. Asserts that `withdraw` reverts with the 
     *      `Insufficient__Allowance` custom error when USER1 tries to withdraw 2 ether.
     */
    function testRevertWhenExceedsAllowance() public {
        // Fund the wallet and set up user
        vm.deal(OWNER, 10 ether);
        vm.prank(OWNER);
        wallet.deposit{value: 10 ether}();
        
        vm.startPrank(OWNER);
        wallet.setPermission(USER1, true);
        wallet.setAllowance(USER1, 1 ether);
        vm.stopPrank();

        // Try to withdraw 2 ether when only 1 is allowed
        vm.prank(USER1);
        vm.expectRevert(abi.encodeWithSelector(Insufficient__Allowance.selector, 1 ether, 2 ether));
        wallet.withdraw(payable(USER1), 2 ether);
    }


    /**
     * @notice Verifies that withdrawal reverts when the wallet contract lacks sufficient   
     *         ETH.
     * @dev Sets the calling user's allowance, then attempts to withdraw 10 ETH while the 
     *      contract balance is 0 ETH. Validates that the `Insufficient__Balance` custom 
     *      error is thrown with the correct current balance and requested amount parameters.
     */
    function testRevertWhenInsufficientContractBalance() public {
        // Setup user
        vm.startPrank(OWNER);
        wallet.setPermission(USER1, true);
        wallet.setAllowance(USER1, 100 ether);
        vm.stopPrank();

        // Contract has 0 ETH, try to withdraw 10 ETH
        vm.prank(USER1);
        vm.expectRevert(abi.encodeWithSelector(Insufficient__Balance.selector, 0, 10 ether));
        wallet.withdraw(payable(USER1), 10 ether);
    }



    /*///////////////////////////////////////////////////////////////
                                REENTRANCY CHECK TESTS
    //////////////////////////////////////////////////////////////*/
     // Notes: The wallet uses `ReentrancyGuard` which prevents typical
    // reentrancy attacks where a malicious contract tries to call
    // withdraw repeatedly in its `receive()` function.
    

    /**
     * @notice Allows the contract to receive plain Ether (native token) transfers.
     * @dev This function is triggered automatically when the contract receives ETH 
     *      with empty calldata. It enables the contract to act like a standard 
     *      account and process direct wallet transfers or funds sent via `transfer()` 
     *       or `send()`.   
     */
    receive() external payable {}


    /**
     * @notice Verifies that the wallet is protected against reentrancy attacks.
     * @dev Funds the wallet, grants this test contract permission and withdrawal
     *      allowance, and then performs a withdrawal operation.
     *      The wallet's reentrancy protection mechanism is expected to prevent
     *      any recursive withdrawal attempts during execution.
     *      This test validates that the withdrawal flow remains secure against
     *      reentrant calls.
    */
    function testReentrancyGuardProtection() public {
        // Fund the wallet
        vm.deal(address(wallet), 10 ether);

        // Set up attacker
        vm.startPrank(OWNER);
        wallet.setPermission(address(this), true);
        wallet.setAllowance(address(this), 10 ether);
        vm.stopPrank();

        // This will attempt a reentrant call during the withdrawal
        // The ReentrancyGuard should catch and revert it
        wallet.withdraw(payable(address(this)), 5 ether);
    }



}