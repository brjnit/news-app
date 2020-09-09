//
//  CacheDataProvider.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit

class CacheDataProvider {
	private let cachedData = NSCache<AnyObject, AnyObject>()
	private let cachedImage = NSCache<AnyObject, AnyObject>()
	static let shared: CacheDataProvider = CacheDataProvider()
	func setDataToCache(for data: [Article]) {
		cachedData.setObject(data as AnyObject, forKey: "content" as AnyObject)
	}

	func readDataFromCache() -> [Article]? {
		return cachedData.object(forKey: "content" as AnyObject) as? [Article]
	}

	func setImageToCache(key: String, value: String) {
		if let data = value.base64Decoded,
			let image = UIImage(data: data) {
			cachedImage.setObject(image as AnyObject, forKey: key as AnyObject)
		}
	}

	func readImageFromCache(key: String) -> UIImage? {
		return cachedImage.object(forKey: key as AnyObject) as? UIImage
	}

}
