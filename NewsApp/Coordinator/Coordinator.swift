//
//  AppCoordinator.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import Foundation

protocol Coordinator: class {
	var childCoordinators: [Coordinator] {get set}
	func start()
}

extension Coordinator {
	func add(coordinator: Coordinator) -> Void {
		childCoordinators.append(coordinator)
	}

	func remove(coordinator: Coordinator) -> Void {
		childCoordinators = childCoordinators
			.filter({ $0 !== coordinator})
	}
}

class BaseCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []

	func start() {
		fatalError("children should implement BaseCoordinator")
	}
}


