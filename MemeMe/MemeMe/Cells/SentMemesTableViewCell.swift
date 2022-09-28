//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Justin Bengtson on 9/24/22.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func setup(with model: Meme) {
        memeImage.image = model.memeImage
    }
    
}
