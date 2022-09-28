//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Justin Bengtson on 9/24/22.
//

import UIKit

class SentMemesCollectionController: UIViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    @IBOutlet weak var memeCollectionView: UICollectionView!
    let sentMemesCollectionViewCellIdentifier = "sentMemesCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        memeCollectionView.dataSource = self
        memeCollectionView.delegate = self
        setupCollectionViewFlowLayout()
    }
    
    private func setupCollectionViewFlowLayout() {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}

extension SentMemesCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sentMemesCollectionViewCellIdentifier, for: indexPath) as! SentMemesCollectionViewCell
        let meme = memes[indexPath.row]
        cell.memeImage.image = meme.memeImage
        return cell
    }
    
    
}

extension SentMemesCollectionController: UICollectionViewDelegate {
    
}
