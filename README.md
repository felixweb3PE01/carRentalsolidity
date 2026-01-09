# Car Rental Smart Contract

A decentralized car rental system built on the Ethereum blockchain using Solidity. This smart contract enables peer-to-peer car rentals with automatic payment processing and rental status tracking.

## Overview

This smart contract implements a simple car rental service where users can rent a car by paying the specified rental price in ETH. The contract manages rental status, tracks all renters, and ensures only one person can rent the car at a time.

## Features

- **Immutable Rental Price**: The rental price is set during contract deployment and cannot be changed
- **Single Active Rental**: Only one user can rent the car at a time
- **Renter History**: Maintains a complete history of all addresses that have rented the car
- **Owner Controls**: Only the contract owner can withdraw accumulated funds
- **Secure Returns**: Only the current renter can return the car
- **Payment Validation**: Ensures sufficient funds are provided before allowing rental

## Contract Architecture

### State Variables

- `balance`: Tracks the contract's current balance
- `owner`: Address of the contract owner (set at deployment)
- `isrented`: Boolean flag indicating if the car is currently rented
- `rentalprice`: The fixed price to rent the car (immutable)
- `renters`: Array storing all addresses that have rented the car
- `currentRenter`: Address of the person currently renting the car

### Custom Errors

The contract uses custom errors for gas-efficient error handling:

- `Insufficientfund()`: Thrown when rental payment is below the required price
- `Rented()`: Thrown when attempting to rent an already rented car
- `UnauthorizedAccess()`: Thrown when unauthorized users attempt restricted actions
- `PriceNotAdded()`: Thrown when rental price is set to zero during deployment

## Functions

### Public/External Functions

**`constructor(uint256 _rentalprice)`**
- Initializes the contract with a rental price
- Sets the deployer as the owner
- Accepts initial ETH deposit
- Reverts if rental price is set to zero

**`rentalAddressbook()`**
- Returns the complete list of all addresses that have ever rented the car
- View function (no gas cost when called externally)

**`rentCar()`**
- Allows users to rent the car by sending ETH
- Validates payment amount against rental price
- Checks if car is available (not currently rented)
- Updates rental status and records the renter
- Returns success message upon completion

**`returnCar()`**
- Allows the current renter to return the car
- Verifies caller is the current renter
- Updates rental status to available

**`withdraw()`**
- Restricted to contract owner only
- Intended for owner to withdraw accumulated rental payments
- *Note: Implementation is incomplete in current version*

### Modifiers

**`restrict()`**
- Ensures only the contract owner can execute certain functions
- Used to protect administrative functions like withdraw

## Usage

### Deployment

1. Deploy the contract with your desired rental price in wei
2. Optionally send initial ETH with deployment to fund the contract

```solidity
// Example: Deploy with 1 ETH rental price
constructor(1000000000000000000)
```

### Renting a Car

1. Call `rentCar()` function
2. Send ETH equal to or greater than the rental price
3. If successful, you become the current renter

### Returning a Car

1. As the current renter, call `returnCar()`
2. The car becomes available for the next renter

### Viewing Rental History

1. Call `rentalAddressbook()` to see all past renters

## Security Considerations

- The contract owner has privileged access to withdrawal functions
- Only the current renter can return the car, preventing unauthorized returns
- Custom errors provide clear feedback while saving gas
- Rental price is immutable, preventing price manipulation after deployment

## Known Limitations

1. **Incomplete Withdraw Function**: The `withdraw()` function has no implementation body
2. **No Time-Based Rentals**: No automatic return after a time period
3. **No Refund Mechanism**: Overpayments are not refunded to renters
4. **Single Car Only**: Contract manages only one car at a time
5. **Balance Not Updated**: The `balance` variable is set in constructor but never updated with rental payments

## Potential Improvements

- Implement the withdraw function to transfer funds to owner
- Add time-based rental periods with automatic returns
- Implement refund mechanism for overpayments
- Add rental duration tracking
- Include car metadata (model, year, location)
- Implement rating/review system
- Add damage deposit functionality
- Support multiple cars per contract

## Development Environment

- **Solidity Version**: ^0.8.31
- **License**: MIT
- **Compiler**: Compatible with Remix IDE, Hardhat, or Foundry

## Testing Recommendations

Before mainnet deployment, thoroughly test:
- Rental with exact price
- Rental with overpayment
- Rental attempt when car is already rented
- Return by non-renter
- Multiple sequential rentals
- Owner withdrawal functionality
- Edge cases with zero addresses

## License

This project is licensed under the MIT License.

---

**⚠️ Disclaimer**: This contract is for educational purposes. Audit thoroughly before using with real funds on mainnet.
