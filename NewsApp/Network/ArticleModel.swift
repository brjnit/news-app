//
//  ArticleModel.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import Foundation

struct Articles: Decodable {
	let articles: [Article]
}

struct Article: Decodable {
	var title: String
	var description: String
	var url: String
	var urlToImage: String
	var author: String?
	var publishedAt: String
}
