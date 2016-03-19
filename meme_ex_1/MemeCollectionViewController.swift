//
//  MemeCollectionViewController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 17/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    var memes : [Meme]!
    // Collection
    @IBOutlet weak var memeFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space : CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        memeFlowLayout.minimumInteritemSpacing = space
        memeFlowLayout.minimumLineSpacing = space
        memeFlowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MeMeCollectionViewCell", forIndexPath: indexPath) as! CustomMemeCell
        let meme = memes[indexPath.item]
        //cell.setText(meme.topString, bottomString: meme.bottomString)
        let imageView = UIImageView(image: meme.memeImage)
        cell.backgroundView = imageView
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}
