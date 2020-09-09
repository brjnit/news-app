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
		if let urlString = url {
			if let imageFromCache = CacheDataProvider.shared.readImageFromCache(key: urlString) {
				DispatchQueue.main.async() { [weak self] in
					self?.image = imageFromCache
				}
			} else if let url = URL(string: urlString) {
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
}

enum DateTimeFormat: String {
	case publishedDateFormat = "yyyy-MM-ddThh:mm:ssZ"
}
