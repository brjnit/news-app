//
//  Helper+Extentions.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit


//MARK: UIImageView helpers
extension UIImageView {

	func loadImage(with url: String?, contentMode mode: UIView.ContentMode = .scaleToFill ) {
		image = nil
		contentMode = mode
		if let urlString = url, let url = URL(string: urlString) {
			//cacheImageUrl(url)
			if let imageFromCache = CacheDataProvider.shared.readImageFromCache(key: urlString) {
				DispatchQueue.main.async() { [weak self] in
					self?.image = imageFromCache
				}
			} else {
				loadImage(from: url, contentMode: mode)
			}
		}
	}

	func loadImage(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
		DispatchQueue.global().async { [weak self] in
			if let data = try? Data(contentsOf: url) {
				if let image = UIImage(data: data) {
					DispatchQueue.main.async() { [weak self] in
						self?.image = image
					}
				}
			}
		}
	}

	func updateImageView(toImage image: UIImage?) {
		UIView.transition(with: self, duration: 0.1,
						  options: [.curveEaseIn],
						  animations: {
							self.image = image
		},
						  completion: nil)
	}


	func cacheImageUrl(_ url: URL) {
		let cache = URLCache.shared
		let urlRequest = URLRequest(url: url)
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			if let data = cache.cachedResponse(for: urlRequest)?.data, let image = UIImage(data: data) {
				DispatchQueue.main.async() { [weak self] in
					self?.updateImageView(toImage: image)
				}
			} else {

				URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
					if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500)<300, let image = UIImage(data: data) {
						let cacheData = CachedURLResponse(response: response , data: data)
						cache.storeCachedResponse(cacheData, for: urlRequest)
						DispatchQueue.main.async() { [weak self] in
							self?.updateImageView(toImage: image)
						}
					}
				}
			}
		}
	}
}

//MARK: String helpers
extension String {

	var base64Decoded: Data? { return Data(base64Encoded: self) }

	func convertStringToDate(from givenFormat: DateTimeFormat = DateTimeFormat.publishedDateFormat) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = givenFormat.rawValue
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		return dateFormatter.date(from: self)
	}

	func formatDate(from givenFormat: DateTimeFormat = DateTimeFormat.publishedDateFormat,
					to resultFormat: DateTimeFormat = DateTimeFormat.displayDate) -> String {
		let dateFormatter = DateFormatter()
		guard let date = self.convertStringToDate(from: givenFormat) else { return self }
		dateFormatter.dateFormat = resultFormat.rawValue
		let dateString = dateFormatter.string(from: date)
		return dateString
	}
}

enum DateTimeFormat: String {
	case publishedDateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
	case displayDate = "dd MMMM yyyy, hh:mm a"
}
