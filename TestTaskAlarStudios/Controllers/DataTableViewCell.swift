//
//  DataTableViewCell.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 29.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet var picture: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    var dataTask: URLSessionDataTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        picture.contentMode = .scaleAspectFill
        picture.layer.cornerRadius = 6.0
        picture.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dataTask?.cancel()
        dataTask = nil
        configure(with: .none)
    }
    
    func configure(with airport: Airport?) {
        if let airport = airport {
            nameLabel.text = airport.name
            nameLabel.alpha = 1
            picture.image = UIImage(named: "Placeholder")
            dataTask = picture.loadImage(fromURL: airport.imageURL)
            picture.alpha = 1
            
            indicatorView.stopAnimating()
        } else {
            nameLabel.alpha = 0
            picture.alpha = 0
            
            indicatorView.startAnimating()
        }
    }
}
