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
    var memes : [Meme]!
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell")
        let meme = self.memes[indexPath.row]
        
        cell!.textLabel?.text = meme.topString
        cell!.imageView?.image = meme.memeImage
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
