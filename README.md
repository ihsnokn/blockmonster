# BlockMonster Game Smart Contract

This is a smart contract for the BlockMonster game, implemented on the SUI blockchain platform.

## Overview

The BlockMonster game contract allows users to create, equip, and exchange game monsters with various attributes. Monsters can have armor, and players can initiate exchanges using wrapping objects.

### Installation

1. Clone the repository: `git clone https://github.com/your-username/blockmonster-game.git`
2. Compile the smart contract using the SUI compiler.
3. Deploy the compiled contract on the SUI blockchain.

## Usage

There is a version in the devnet that I added, you can find it in this address:
0xe9f52ecac9d9fd2ee40a711f090bc4510ac058460c26f71a345c2cab31f151a2

ID of AdminCap:
0xdfbec5d53d9947f55181745b58da8ccbbe0fc9ae41f523ee7c26d841ba55b5e0

ID of UpgradeCap:
0x9d48f2f6f0f164a6cc39cfe721f983eb6bdb80fcd0d1ea2688582dd89489274f

#There are two fuctions you can run at the beginning:

1-create_monster()
  parameters are --> (admincap, recipient address, name of the monster, rarity of the monster, attack power of the monster, defence of the monster, velocity of the monster) respectively.
  
2-create_armor()
  parameters are --? (bonus speed, bonus defence) respectively
  
#After this you can equip created armor to created monster using equip_armor() function. You can trade monsters with other addresses that have monsters.

### Initializing the Contract

To initialize the contract, execute the `init` function, which will set up the necessary administrative capabilities.

*Had no time to write tests...

