//
//  Cryptocurrency.swift
//  Prefetch
//
//  Created by Soul on 17/07/2018.
//  Copyright © 2018 Fluffy. All rights reserved.
//

import Foundation

struct CoinList : Decodable {
	let data : [String : Coin]
}

struct Coin : Decodable {
	let id : Int
	let name : String
	let symbol : String
	let rank : Int
	let quotes : [String : Price]
}

struct Price : Decodable {
	let price : Double
}
