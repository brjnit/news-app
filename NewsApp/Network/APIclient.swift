//
//  APIclient.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import Foundation

enum CustomError: Error {
	case error(message: String)
}

enum APIError: Error {
	case forbidden              //Status code 403
	case notFound               //Status code 404
	case conflict               //Status code 409
	case internalServerError
}

enum ArticleURLs: String {
	case articles = "https://moedemo-93e2e.firebaseapp.com/assignment/NewsApp/articles.json"
}

protocol NewsAPI {
	typealias NewsResult = (Result<[Article], Error>) -> Void
	func newsAPIRequest(_ handler: @escaping NewsAPI.NewsResult)
}

//MARK: Api request using URLsession

class APIClient: NewsAPI {

	let session = URLSession.shared

	func newsAPIRequest(_ handler: @escaping NewsAPI.NewsResult) {

		guard let url = URL(string: ArticleURLs.articles.rawValue) else {
			return
		}
		let task = session.dataTask(with: url, completionHandler: {data, response, error in
			if let error = error {
				handler(.failure(error))
			}else {
				do {
					let jsonResponse = try JSONDecoder().decode(Articles.self, from: data!)
					handler(.success(jsonResponse.articles))
				} catch {
					handler(.failure(CustomError.error(message: "Json parsing error")))
				}
			}
		})
		task.resume()
	}
}


