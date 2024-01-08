// Copyright (c) Sui Foundation, Inc.
// SPDX-License-Identifier: Apache-2.0
#[test_only]
module blockmonster::game_test {
    use blockmonster::game::{Self, AdminCap, Monster, Armor, WrappingMonster};
    //use sui::coin::{Coin, into_coin};
    use sui::test_scenario::{Self as ts, next_tx, ctx};

    #[test]
    fun test_game_functions() {
        // Initialize a mock sender address
        let addr1 = @0xA;
        let addr2 = @0xB;

        // Begins a multi-transaction scenario with addr1 as the sender
        let scenario = ts::begin(addr1);

        // Run the game module init function
        {
            game::init(ctx(&mut scenario));
        };

        // Test creating a monster and adding armor
        next_tx(&mut scenario, addr1);
        {
            game::create_monster(game::AdminCap { id: object::new(ctx(&mut scenario)) }, addr1, test, 1, 10, 5, 7, ctx(&mut scenario));
            game::create_armor(2, 3, ctx(&mut scenario));
            let monster = ts::take_from_sender<Monster>(&scenario);
            let armor = ts::take_from_sender<Armor>(&scenario);
            game::equip_armor(&mut monster, armor, ctx(&mut scenario));
        };

        // Test requesting an exchange
        next_tx(&mut scenario, addr1);
        {
            let monster = ts::take_from_sender<Monster>(&scenario);
            let fee = 1500;
            game::request_exchange(monster, fee, addr2, ctx(&mut scenario));
        };

        // Test executing a swap
        next_tx(&mut scenario, addr2);
        {
            let wrapper1 = ts::take_from_sender<WrappingMonster>(&scenario);
            let wrapper2 = ts::take_from_sender<WrappingMonster>(&scenario);
            game::execute_swap(wrapper1, wrapper2, ctx(&mut scenario));
        };

        // Clean up the scenario object
        ts::end(scenario);
    }
}
