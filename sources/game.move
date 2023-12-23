//this contract is prepared for rise in move on sui hackaton

module blockmonster::game {
	
	// moduller
	use std::string::{String, utf8};
	use std::option::{Self, Option};
	use sui::object::{Self, UID};
	use sui::transfer;
	use sui::sui::SUI;
	use sui::balance::{Self, Balance};
	use sui::coin::{Self, Coin};
	use sui::tx_context::{Self, TxContext};


	// constanlar
	const MIN_FEE: u64 = 1000;
	

	// yonetici
	
	struct AdminCap has key {
		id: UID
	}

	//armor
	struct Armor has key, store {
		id: UID,
		bonus_speed: u8,
		bonus_defence: u8,
	}

	//canavar
	struct Monster has key, store{
		id: UID,
		name: String,
		rarity: u8,
		attack: u8,
		defence: u8,
		velocity: u8,
		armor: Option<Armor>
		
	}
	
	// wrap the main object into an object that can be transferred
	struct WrappingMonster has key {
		id: UID,
		original_owner: address,
		monster_swap: Monster,
		fee: Balance<SUI>,
	}
	
	// init fonksiyon
	// admincap ekle
	fun init (ctx: &mut TxContext) {
		transfer::transfer(AdminCap {id: object::new(ctx)}, tx_context::sender(ctx))
	}

	// fonksiyonlar

	// minter
	// only admincap can execute
	public entry fun create_monster(_: &AdminCap, to: address, name: String, rarity: u8, attack: u8, defence: u8, velocity: u8, ctx: &mut TxContext){
		//canavar olustru
		let monster = Monster {
			id: object::new(ctx),
			name: name,
			rarity: rarity,
			attack: attack,
			defence: defence,
			velocity: velocity,
			armor: option::none(),
		};
		//canavar transfer
		transfer::transfer(monster, to);

	}		

	//  add armor to monster
	public entry fun create_armor(bonus_speed: u8, bonus_defence: u8, ctx: &mut TxContext) {
		let armor = Armor {
			id: object::new(ctx),
			bonus_speed: bonus_speed,
			bonus_defence: bonus_defence,
		};
		transfer::transfer(armor, tx_context::sender(ctx));
	}

	public entry fun equip_armor(monster: &mut Monster, armor: Armor, ctx: &mut TxContext) {
		if(option::is_some(&monster.armor)) {
			// armoru sender adresine yolla
			let armor_old = option::extract(&mut monster.armor);
			transfer::transfer(armor_old, tx_context::sender(ctx));
		};
		// yeni armoru canavara gonder
		option::fill(&mut monster.armor, armor);
	}

	// exchange
	// wrapping object ile canavarlkari swapla
	public entry fun request_exchange(monster: Monster, fee: Coin<SUI>, service_address: address, ctx: &mut TxContext) {

		//minimum fee check
		assert!(coin::value(&fee) >= MIN_FEE, 0);

		// wrapping object olustur monster wrappingmonstera ekle
		let wrapper = WrappingMonster {
			id: object::new(ctx),
			original_owner: tx_context::sender(ctx),
			monster_swap: monster,
			// coini yok et
			fee: coin::into_balance(fee),
		};
		// paketlenmis objecti swap servisni cagirana yolla
		transfer::transfer(wrapper, service_address);
	}
	
	public entry fun execute_swap(wrapper_monster1: WrappingMonster, wrapper_monster2: WrappingMonster, ctx: &mut TxContext) {
		// ayni nadirlikte olduklarini check
		assert!(wrapper_monster1.monster_swap.rarity == wrapper_monster2.monster_swap.rarity, 0);

		//unpackle 
		let WrappingMonster {
			id: id1,
			original_owner: original_owner1,
			monster_swap: monster1,
			fee: fee1,
		} = wrapper_monster1;

		let WrappingMonster {
			id: id2,
			original_owner: original_owner2,
			monster_swap: monster2,
			fee: fee2,
		} = wrapper_monster2;
	
		// yeni sahiplerine transfer
        transfer::transfer(monster1, original_owner2);
        transfer::transfer(monster2, original_owner1);

        // saglayici fee al
        let service_address = tx_context::sender(ctx);
		//2 balance birlestir
        balance::join(&mut fee1, fee2);
        transfer::public_transfer(coin::from_balance(fee1, ctx), service_address);

        // wrappingmonster lazim degil
        object::delete(id1);
        object::delete(id2);
	}

	// property kontrol

	public fun view_attack(monster: &Monster): u8 {
		monster.attack
	}

	public entry fun increase_attack (monster: &mut Monster, increment: u8) {
		monster.attack = monster.attack + increment
	}

	
}