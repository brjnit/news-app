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

class APIClient {

	let session = URLSession.shared

	func newsAPIRequest(handler: @escaping (Result<[Article], Error>) -> Void) {
		guard let url = URL(string: "https://moedemo-93e2e.firebaseapp.com/assignment/NewsApp/articles.json") else {
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
