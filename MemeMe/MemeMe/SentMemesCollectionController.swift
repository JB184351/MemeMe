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
        registerCollectionViewCell()
        memeCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeCollectionView.reloadData()
    }
    
    private func setupCollectionView() {
        memeCollectionView.dataSource = self
        memeCollectionView.delegate = self
    }
    
    private func registerCollectionViewCell() {
        memeCollectionView.register(SentMemesCollectionViewCell.nib, forCellWithReuseIdentifier: sentMemesCollectionViewCellIdentifier)
    }
    
    
    @IBAction func createMemeAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeViewController = storyboard.instantiateViewController(withIdentifier: "memeViewController") as! MemeViewController
        navigationController?.pushViewController(memeViewController, animated: true)
    }
}

//MARK: - CollectionViewDataSource
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

//MARK: - CollectionViewDelegateFlowLayout
extension SentMemesCollectionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
