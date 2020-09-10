//
//  NewsDetailScreen.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: BaseViewController, WKNavigationDelegate {
	let cache = URLCache.shared
	private let webView: WKWebView = {
		let webView = WKWebView()
		webView.translatesAutoresizingMaskIntoConstraints = false
		return webView
	}()
	var viewModel: NewsDetailViewModel!
	override func viewDidLoad() {
		
		view.addSubview(webView)
		webView.navigationDelegate = self
		setupConstraints()
		loadingIndicator(show: true)
		viewModel.displaySelectedArticle { [weak self] url in
			guard let url = URL(string: url) else {
				return
			}
			var urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
			let status = Reachability().connectionStatus()
			switch status {
				case .unknown, .offline:
					urlRequest.cachePolicy = .returnCacheDataDontLoad
					guard let cachedResponse = cache.cachedResponse(for: urlRequest),
						let htmlString = String(data: cachedResponse.data, encoding: .utf8) else {
							return
					}
					webView.loadHTMLString(htmlString, baseURL: url)
				default: self?.webView.load(urlRequest)
				DispatchQueue.global(qos: .background).async { [weak self] in
					URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
						if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500)<300 {
							let cacheData = CachedURLResponse(response: response , data: data)
							self?.cache.storeCachedResponse(cacheData, for: urlRequest)
						}
					}
				}
			}
		}
	}
	//MARK: setup view
	private func setupConstraints() {
		webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}

	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
	{
		print("didStartProvisionalNavigation")
	}

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		loadingIndicator(show: false)
//		webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { html, error in
//		})
	}

	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		print("didFailProvisionalNavigation ",error)
	}

	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		print("didFail ",error)
	}
}
