//
//  MeMeTableViewController.swift
//  meme_ex_2
//
//  Created by Ricardo Griffith on 17/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import Foundation
import UIKit

class MeMeTableViewController: UITableViewController {
    // Array of Meme objects.
    var memes : [Meme]!
    
    // dismiss the current view to display the construct Meme scene.
    @IBAction func addMeme(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Centralized model
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of Meme objects in Array.
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell")
        let meme = self.memes[indexPath.row]
        
        // Populate the object with data.
        cell!.textLabel?.text = "\(meme.topString)...\(meme.bottomString)"
        cell!.imageView?.image = meme.memeImage
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewControllerWithIdentifier("details") as! MemeDetailedController
        let meme = self.memes[indexPath.row]
        nextViewController.meme = meme
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
