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
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var descriptionLabel: UILabel!
	@IBOutlet  var newsImageView: UIImageView!

	public func configure(with model: NewsModel) {
		self.newsImageView.loadImage(with: model.imageName)
		self.titleLabel?.text = model.title
		self.descriptionLabel?.text = model.description
	}

	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
