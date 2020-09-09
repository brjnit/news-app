//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit

struct NewsModel {
	let imageName: String?
	let title: String
	let description: String
}

enum State {
	case success(models: [NewsModel])
	case error(error: Error)
}

class ArticleViewModel {
	private let router: ArticleRouter
	private(set) var articles: [Article] = []
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	init(router: ArticleRouter) {
		self.router = router
	}

	func loadArticles(displayUI: @escaping (State) -> Void) {
		if let dataFromCache = CacheDataProvider.shared.readDataFromCache() {
			displayUI(.success(models: mapDataForView(articles: dataFromCache)))
		} else {
			let api = APIClient()
			api.newsAPIRequest { [weak self] result in
				print(result)
				switch result {
					case .success(let articles):
						self?.articles = articles
						self?.saveForOffline(articles: articles)
						guard let models = self?.mapDataForView(articles: articles) else {
							return displayUI(.error(error: CustomError.error(message: "Json formating error. ")))
						}
						displayUI(.success(models: models))
					case .failure( let error):
					//TODO: Add failure case
						displayUI(.error(error: error))
//						guard let models = self?.loadForOffline() else {
//							return displayUI(.error(error: error))
//						}
//						displayUI(.success(models: models))
				}

			}
		}
	}

	func saveForOffline(articles: [Article]) {
		LocalDataProvider.shared.clearData()
		LocalDataProvider.shared.saveData(articles: articles)
		CacheDataProvider.shared.setDataToCache(for: articles)
	}

	func loadForOffline() -> [NewsModel] {
		let data = LocalDataProvider.shared.loadData()
		LocalDataProvider.shared.loadImageFromStorage()
		return mapDataForView(articles: data)
	}

	func mapDataForView(articles: [Article]) -> [NewsModel] {
		return articles.map{ NewsModel(imageName: $0.urlToImage,
												 title: $0.title,
												 description: $0.description)
		}
	}

	func filteredArticles(searchText: String, searchedView: @escaping (State) -> Void) {
		let filteredArticles = searchText == "" ? articles: articles.filter { ($0.author?.contains(searchText) ?? true)}
		searchedView(.success(models: mapDataForView(articles: filteredArticles)))
	}

	func selectedArticle(for index: Int) {
		router.routeToNewsDetail(urlString: articles[index].url)
	}

	func sortArticles(by newToOld: Bool, sortedView: @escaping (State) -> Void) {
		let sortedArticles = articles.sorted (by: {
			sortByDate($0, $1, ascending: newToOld)
		})
		sortedView(.success(models: mapDataForView(articles: sortedArticles)))
	}

	func sortByDate(_ a1: Article, _ a2: Article, ascending: Bool) -> Bool {
		guard let d1 = a1.publishedAt.convertStringToDate(),
			let d2 = a2.publishedAt.convertStringToDate() else {
			return false
		}
		return ascending ? d1>d2 : d2>d1

	}
}
