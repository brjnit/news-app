//
//  BaseViewController.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
	var loading: UIView?

	func loadingIndicator(show: Bool) {
		if show {
			showLoading()
		} else {
			hideLoading()
		}
	}
	private func showLoading() {
		let loadingView = UIView.init(frame: self.view.bounds)
		loadingView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
		let activity = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
		activity.startAnimating()
		activity.center = loadingView.center

		DispatchQueue.main.async {
			loadingView.addSubview(activity)
			self.view.addSubview(loadingView)
		}
		loading = loadingView
	}

	private func hideLoading() {
		DispatchQueue.main.async {
			self.loading?.removeFromSuperview()
			self.loading = nil
		}
	}
}

extension UIViewController {
	func customNavigationTitle(title: String?) {
		let label = UILabel()
		label.text = title
		label.font = UIFont(name: "Roboto-Medium", size: 20)
		label.textColor = UIColor.white
		label.textAlignment = .center
		self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
	}
}



