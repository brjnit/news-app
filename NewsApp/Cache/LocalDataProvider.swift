//
//  LocalDataProvider.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit
import CoreData

class LocalDataProvider {
	private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	static let shared: LocalDataProvider = LocalDataProvider()

	//MARK: setup core data context
	private func saveToContext() {
		do {
			try context.save()
		} catch  {
			print("Error in saving \(error)")
		}
	}

	func saveData(articles: [Article]) {
		_ = articles.map { item in
			guard let url = URL(string: item.urlToImage) else { return }
			DispatchQueue.global().async { [weak self] in
				if let strongSelf = self, let data = try? Data(contentsOf: url) {
					let imageString = data.base64EncodedString()
					let contextItem = ArticleModel(context: strongSelf.context)
					contextItem.url = item.url
					contextItem.title = item.title
					contextItem.desc = item.description
					contextItem.author = item.author
					contextItem.publishedAt = item.publishedAt
					contextItem.imageData = imageString

					strongSelf.saveToContext()
					CacheDataProvider.shared.setImageToCache(key: item.urlToImage,
															 value: imageString)
				}
			}
		}
	}

	func loadData() -> [Article] {
		let request: NSFetchRequest<ArticleModel> = ArticleModel.fetchRequest()
		do {
			let data = try context.fetch(request)
			let storedData = data.map { item in
				return Article(title: item.title ?? "",
							   description: item.desc ?? "",
							   url: item.url ?? "",
							   urlToImage: item.urlToImage ?? "",
							   author : item.author,
							   publishedAt : item.publishedAt ?? ""
				)
			}
			CacheDataProvider.shared.setDataToCache(for: storedData)
			return storedData
		} catch  {
			print("Error in fetching")
		}
		return []
	}

	func loadImageFromStorage()  {
		let request: NSFetchRequest<ArticleModel> = ArticleModel.fetchRequest()
		do {
			let data = try context.fetch(request)
			_ = data.map { item in
				if let url = item.url, let imageData = item.imageData {
					CacheDataProvider.shared.setImageToCache(key: url,
															 value: imageData)
				}
			}
		} catch  {
			print("Error in fetching")
		}
	}

	func clearData() {
		let request: NSFetchRequest<ArticleModel> = ArticleModel.fetchRequest()
		do {
			let data = try context.fetch(request)
			_ = data.map{context.delete($0)}
			try context.save()
		} catch  {
			print("Error in saving \(error)")
		}
	}

	func updateToContext(key: String, value: String) {
		let item = ArticleModel(context: context)
		item.setValue(value, forKey: key)
		saveToContext()
	}
}
