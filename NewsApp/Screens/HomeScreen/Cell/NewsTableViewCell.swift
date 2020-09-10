//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Brajesh Kumar on 08/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

	static let identifier = "newsCell"
	static func nib () -> UINib {
		return UINib(nibName: "NewsTableViewCell", bundle: nil)

	}
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var descriptionLabel: UILabel!
	@IBOutlet private weak var newsImageView: UIImageView!
	@IBOutlet private weak var publishOn: UILabel!

	public func configure(with model: NewsModel) {
		self.newsImageView.loadImage(with: model.imageName)
		self.titleLabel?.text = model.title
		self.descriptionLabel?.text = model.description
		self.publishOn?.text = model.publishOn.formatDate()
	}

	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
