//
//  ArticleCoordinator.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit

class ArticleCoordinator: BaseCoordinator {
	private let navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	override func start() {
		let vc = HomeViewController()
		vc.customNavigationTitle(title: Constant.homeScreenTitle)
		navigationController.pushViewController(vc, animated: true)
	}
}



