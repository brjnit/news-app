//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
	private var newsModel: [NewsModel] = []
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()
	private var viewModel: ArticleViewModel!

	private let searchController = UISearchController(searchResultsController: nil)
	private var sorted: Bool = true
	private var newToOldBarButton: UIBarButtonItem?
	private var oldToNewBarButton: UIBarButtonItem?

	override func viewDidLoad() {
		super.viewDidLoad()
		let router = ArticleRouter(self)
		viewModel = ArticleViewModel(router: router)
		setupSearchView()
		setupView()
		setupConstraints()
		loadingIndicator(show: true)
		viewModel.loadArticles(displayUI: { [weak self] state in
			self?.updateView(state: state)
			self?.loadingIndicator(show: false)
		})
	}

	func updateView(state: State) {
		switch state {
			case .success(let models):
				newsModel = models
				DispatchQueue.main.async {
					self.tableView.reloadData()

			}
			case .error(let error):
				let alert = UIAlertController(title: "Error",
											  message: error.localizedDescription,
											  preferredStyle: .alert)

				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

				DispatchQueue.main.async {
					self.present(alert, animated: true)
			}
		}
	}

	//MARK: Search View setup
	func setupSearchView() {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Articles"
		searchController.searchBar.barTintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
		searchController.searchBar.isTranslucent = false
		searchController.searchBar.tintColor = .white
		searchController.searchBar.backgroundImage(for: .topAttached,
												   barMetrics: .default)
		self.newToOldBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.square"),  style: .plain, target: self, action: #selector(sortArticles))
		self.oldToNewBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.square"),  style: .plain, target: self, action: #selector(sortArticles))
		navigationItem.setRightBarButton(newToOldBarButton, animated: true)
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}

	@objc func sortArticles() {
		sorted = !sorted
		self.navigationItem.setRightBarButton((sorted ? newToOldBarButton: oldToNewBarButton), animated: true)
		viewModel.sortArticles(by: false, sortedView: { [weak self] state in
			self?.updateView(state: state)
		})
	}

	//MARK: setup view
	private func setupView() {
		view.addSubview(tableView)
		let nib = NewsTableViewCell.nib()
		tableView.register(nib, forCellReuseIdentifier: NewsTableViewCell.identifier)
		tableView.dataSource = self
		tableView.delegate = self
	}

	private func setupConstraints() {
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return newsModel.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as! NewsTableViewCell
		cell.configure(with: newsModel[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.selectedArticle(for: indexPath.row)
	}
}

extension HomeViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		if let searchText = searchBar.text {
			viewModel.filteredArticles(searchText: searchText) { [weak self] state in
				self?.updateView(state: state)
			}
		}
	}
}

extension HomeViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		print("selectedScope", selectedScope)
	}
}
