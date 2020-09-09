//
//  NewsDetailScreen.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit

class NewsDetailViewController: BaseViewController {

	private let webView: UIWebView = {
		let webView = UIWebView()
		webView.translatesAutoresizingMaskIntoConstraints = false
		return webView
	}()
	var viewModel: NewsDetailViewModel!
	override func viewDidLoad() {
		
		view.addSubview(webView)
		setupConstraints()
		loadingIndicator(show: true)
		viewModel.displaySelectedArticle { [weak self] url in
			guard let url = URL(string: url) else {
				return
			}
			let urlRequest = URLRequest(url: url)
			self?.webView.loadRequest(urlRequest)
			loadingIndicator(show: false)
		}


	}
	//MARK: setup view
	private func setupConstraints() {
		webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
}

