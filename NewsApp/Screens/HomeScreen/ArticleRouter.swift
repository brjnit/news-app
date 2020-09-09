//
//  ArticleRouter.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit

protocol RouterProtocol {
	//Add route methods for next screen flow
}

class ArticleRouter: RouterProtocol {

	private let viewController: UIViewController
	init(_ viewController: UIViewController) {
		self.viewController = viewController
	}

	func routeToNewsDetail(urlString: String) {
		let newsViewController = NewsDetailViewController()
		newsViewController.viewModel = NewsDetailViewModel(url: urlString)
		newsViewController.title = "Article"
		viewController.navigationController?.pushViewController(newsViewController, animated: true)
	}
}
