//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Justin Bengtson on 9/24/22.
//

import UIKit

class SentMemesTableViewController: UIViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    let sentMemesTableViewCellIdentifier = "sentMemesTableViewCell"
    @IBOutlet weak var sentMemesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sentMemesTableView.dataSource = self
        self.sentMemesTableView.delegate = self
        self.sentMemesTableView.register(SentMemesTableViewCell.nib, forCellReuseIdentifier: sentMemesTableViewCellIdentifier)
        sentMemesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sentMemesTableView.delegate = self
        sentMemesTableView.reloadData()
    }
    
    @IBAction func createMemeAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeViewController = storyboard.instantiateViewController(withIdentifier: "memeViewController") as! MemeViewController
        navigationController?.pushViewController(memeViewController, animated: true)
    }
}

extension SentMemesTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sentMemesTableViewCellIdentifier) as! SentMemesTableViewCell
        let meme = memes[indexPath.row]
        cell.setup(with: meme)
        return cell
    }
    
    
}

extension SentMemesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
