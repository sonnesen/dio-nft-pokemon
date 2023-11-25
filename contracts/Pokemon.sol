// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PokemonNFT is ERC721 {

    struct Pokemon {
        string name;
        uint level;
        string img;
    }

    Pokemon[] public pokemons;
    address public gameOwner;

    constructor() ERC721("Pokemon", "PKM") {
        gameOwner = msg.sender;
    }

    modifier onlyOwnerOf(uint monsterId_) {
        require(ownerOf(monsterId_) == msg.sender, "Apenas o dono pode batalhar com este Pokemon");
        _;
    }

    function battle(uint attackingPokemon_, uint defendingPokemon_) public onlyOwnerOf(attackingPokemon_) {
        Pokemon storage attacker = pokemons[attackingPokemon_];
        Pokemon storage defender = pokemons[defendingPokemon_];

        if (attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        } else {
            attacker.level += 1;
            defender.level += 2;
        }
    }

    function createNewPokemon(string memory name_, address to_, string memory img_) public {
        require(msg.sender == gameOwner, "Apenas o dono do jogo pode criar novos Pokemons");
        uint id = pokemons.length;
        pokemons.push(Pokemon(name_, 1, img_));
        _safeMint(to_, id);
    }
}