//
//  News.swift
//  Prefetch
//
//  Created by Soul on 16/07/2018.
//  Copyright © 2018 Fluffy. All rights reserved.
//

import Foundation


struct News: Decodable {
	let title: String
	let url: String?
	let by: String
}
