//
//  Post.swift
//  Prefetch
//
//  Created by Soul on 17/07/2018.
//  Copyright © 2018 Fluffy. All rights reserved.
//

import Foundation

struct Post : Decodable {
	let userID : Int
	let postID : Int
	let title : String
	let body : String
	
	enum CodingKeys : String, CodingKey {
		case userID = "userId"
		case postID = "id"
		case title
		case body
	}
}
