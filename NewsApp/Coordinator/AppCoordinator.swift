//
//  AppCoordinator.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
	private let window: UIWindow

	private let navigationController: UINavigationController = {
		let navigationController = UINavigationController()
		let navigationBar = navigationController.navigationBar
		navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationBar.shadowImage = UIImage()
		navigationBar.barStyle = .black
		navigationBar.tintColor = .white
		navigationBar.barTintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
		navigationBar.isTranslucent = false
		navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
		return navigationController
	}()

	init(window: UIWindow) {
		self.window = window
	}

	override func start() {
		let coordinator = ArticleCoordinator(navigationController: navigationController)
		self.add(coordinator: coordinator)
		coordinator.start()
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}
}
