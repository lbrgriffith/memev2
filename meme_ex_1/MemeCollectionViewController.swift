//
//  MemeCollectionViewController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 17/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    // MARK: Globals
    var applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    // MARK: Actions
    
    // Launch the scene to create and send a Meme.
    @IBAction func addMeme(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MemeScene") as! ViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // Collection
    @IBOutlet weak var memeFlowLayout: UICollectionViewFlowLayout!
    
    // MARK: Overrides

    
    // Notifies the view controller that its view is about to be added to a view hierarchy.
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.reloadData()
    }
    
    // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        let space : CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        memeFlowLayout.minimumInteritemSpacing = space
        memeFlowLayout.minimumLineSpacing = space
        memeFlowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    // Asks your data source object for the number of items in the specified section.
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return applicationDelegate.memes.count
    }
    
    // Asks your data source object for the cell that corresponds to the specified item in the collection view.
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MeMeCollectionViewCell", forIndexPath: indexPath) as! CustomMemeCell
        let meme = applicationDelegate.memes[indexPath.item]

        let imageView = UIImageView(image: meme.memeImage)
        cell.backgroundView = imageView
        
        return cell
    }
    
    // Tells the delegate that the item at the specified index path was selected.
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewControllerWithIdentifier("details") as! MemeDetailedController
        
        let meme = applicationDelegate.memes[indexPath.item]
        nextViewController.meme = meme
        
        self.presentViewController(nextViewController, animated: true, completion: nil)
    }
}
