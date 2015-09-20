//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Adi Li on 20/9/15.
//  Copyright © 2015 Adi Li. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"
private let column: CGFloat = 3
private let spacing: CGFloat = 3

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dimension = (min(view.frame.width, view.frame.height) - ((column - 1) * spacing)) / column
        
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
        let meme = memes[indexPath.item]
        let imageView = UIImageView(image: meme.memedImage)
        imageView.contentMode = .ScaleAspectFill
        cell.backgroundView = imageView
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailViewController
        
        detailVC.memeIndex = indexPath.item
        
        navigationController!.pushViewController(detailVC, animated: true)
    }
}
