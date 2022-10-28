//
//  DisplayMemeViewController.swift
//  MemeMe
//
//  Created by Justin Bengtson on 10/27/22.
//

import UIKit

class DisplayMemeViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeImageView.image = image
    }
}
