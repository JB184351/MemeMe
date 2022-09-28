//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Justin Bengtson on 9/24/22.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImage: UIImageView!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    
    public func setup(with model: Meme) {
        memeImage.image = model.memeImage
    }
    
}
