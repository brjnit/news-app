//
//  NewsDetailViewModel.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//


class NewsDetailViewModel {
	private let url: String

	init(url: String) {
		self.url = url
	}

	func displaySelectedArticle(displayUI: (String) -> Void) {
		displayUI(url)
	}
}
