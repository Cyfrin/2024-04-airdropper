# First Flight #14: Airdropper

# Table of Contents

- [Contest Details](#contest-details)
    - [Prize Pool](#prize-pool)
    - [Stats](#stats)
    - [Disclaimer](#disclaimer)
- [Table of Contents](#table-of-contents)
- [About](#about)
  - [MerkleAirdrop.sol](#merkleairdropsol)
    - [Why are we using this merkle proof thing?](#why-are-we-using-this-merkle-proof-thing)
    - [How do Merkle Proof based airdrops work?](#how-do-merkle-proof-based-airdrops-work)
  - [makeMerkle.js](#makemerklejs)
  - [Deploy.s.sol](#deployssol)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Testing](#testing)
- [Audit Scope Details](#audit-scope-details)
  - [Compatibilities](#compatibilities)
- [Roles](#roles)
- [Known Issues](#known-issues)

[//]: # (contest-details-open)

# Contest Details

### Prize Pool

- High - 100xp
- Medium - 20xp
- Low - 2xp

- Starts: April 25, 2024 Noon UTC
- Ends: May 02, 2024 Noon UTC

### Stats

- nSLOC: 62
- Complexity Scope: 66

### Disclaimer

_This code was created for Codehawks as the first flight. It is made with bugs and flaws on purpose._
_Don't use any part of this code without reviewing it and audit it._


# About

Our team is looking to airdrop 100 USDC tokens on the [zkSync era chain](https://zksync.io/) to 4 lucky addresses based on their activity on the Ethereum L1. The Ethereum addresses are:

```
0x20F41376c713072937eb02Be70ee1eD0D639966C
0x277D26a45Add5775F21256159F089769892CEa5B
0x0c8Ca207e27a1a8224D1b602bf856479b03319e7
0xf6dBa02C01AF48Cf926579F77C9f874Ca640D91D
```

Each address will recieve 25 USDC. 

The codebase was designed to be deployed to the [zkSync era chain](https://zksync.io/) and therefore uses the [zksync-foundry](https://github.com/matter-labs/foundry-zksync) fork of foundry.

## MerkleAirdrop.sol

We have a single smart contract `MerkleAirdrop.sol` that we think looks very good. We based it off the [Uniswap Merkle-Distributor](https://github.com/Uniswap/merkle-distributor). It uses a [merkle proof](https://en.wikipedia.org/wiki/Merkle_tree) to verify that the user is eligible for the airdrop.

The way users `claim` their airdrop is by calling the `claim` function, and passing:
1. Their address
2. The amount they are elligible for
3. The merkle proof

The `claim` function requires a `1e9` ETH fee to be paid, and the owner of the contract is the only one who should be allowed to withdraw it with `claimFees`.

### Why are we using this merkle proof thing?

Let's imagine you're doing an airdrop, what's the first solution that comes to mind? Probably just creating a list of addresses that are elligible to recieve the drop, and just checking users against that list. The smart contract might look like this:

```javascript
mapping(address => bool) public isEligible;

function addEligible(address _address) external {
  isEligible[_address] = true;
}

function claim() external {
  if(isEligible[msg.sender]) {
    // send the airdrop
  }
}
```

The `claim` function looks easy enough, but we have to populate the list by calling `addEligible` for every address. If we have a lot of addresses, this is going to end up costing SO MUCH GAS!

### How do Merkle Proof based airdrops work?

Ok, so clearly we need a better solution, this is where merkle trees come in. It's recommended you read up on Merkle trees to understand this. But you can audit this codebase without really understanding it. You can get by in doing this audit if you just think "so long as the `inputs` in `makeMerkle.js` are correct, the `process` will work correctly". 

But, this is a great time to learn something new :)

## makeMerkle.js

This file is not in scope for the audit, but it's good to know how it works because it's how we are generating the `s_merkleRoot` in our `Deploy.s.sol`. The output of this file is:

1. A merkle root that is used in `s_merkleRoot`
2. An example proof that can be used to test the smart contract for one of the addresses

If you have `node` and `yarn` installed, you can run the file by:

1. Installing dependencies
```
yarn 
```

2. Running the script

```
yarn run makeMerkle
```

Assume that so long as the inputs are correct, the proofs and merkle root are correct.

## Deploy.s.sol

The [Cyfrin/CodeHawks](https://www.cyfrin.io/) team has convinced us that we need to add our Deploy script to being in scope for this competitive audit. All this does is deploy and set up our smart contract. Once this codebase passes audit, we plan on running the script in the makefile to deploy this. 

We use the script found in `makeMerkle.js` to create the `s_merkleRoot`.

## Roles

Onwer - The one who can withdraw the fees earned by the `claim` function.

[//]: # (contest-details-close)

[//]: # (getting-started-open)

# Getting Started 

## Requirements 

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`
- [rust/cargo](https://doc.rust-lang.org/cargo/getting-started/installation.html)
  - You'll know you did it right if you can run `cargo --version` and you see a response like `cargo 1.57.0 (f1edd0429 2022-01-05)`

Optional:
- [nodejs](https://nodejs.org/en/download/)
  - You'll know you did it right if you can run `node --version` and you see a response like `v16.13.0`
- [yarn](https://classic.yarnpkg.com/en/docs/install)
  - You'll know you did it right if you can run `yarn --version` and you see a response like `1.22.17`

## Installation 

1. Install `foundry-zksync`
There are a few [prerequiste steps](https://github.com/matter-labs/foundry-zksync?tab=readme-ov-file#-prerequisites) to installing this tool. Please see the [official documentation](https://github.com/matter-labs/foundry-zksync?tab=readme-ov-file#-prerequisites) before installing this.

Once you have the prerequisites, you can follow their [quickstart](https://github.com/matter-labs/foundry-zksync?tab=readme-ov-file#quick-install)

This will override your existing `foundry` installation. You can know it's been done properly if you can run the following:

```bash
forge build --help | grep zksync
```

and see an output like:

```
      --zksync
```

2. Clone the repository: 
```bash 
git clone https://github.com/cyfrin/2024-04-airdropper 
cd 2024-04-airdropper 
make 
```

This will build the smart contracts with `forge build --zksync`. 

## Testing

```
forge test --zksync
```

[//]: # (getting-started-close)

[//]: # (scope-open)

# Audit Scope Details

- In Scope:

```
./src/
└── MerkleAirdrop.sol
./script/
└── Deploy.s.sol
```

## Compatibilities

- Solc Version: `0.8.24`
- Chain(s) to deploy contract to:
  - zkSync
- Deployment address:
  - 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045

[//]: # (scope-close)

[//]: # (known-issues-open)

# Known Issues

- None

[//]: # (known-issues-close)
