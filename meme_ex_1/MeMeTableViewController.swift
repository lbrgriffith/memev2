//
//  MeMeTableViewController.swift
//  meme_ex_2
//
//  Created by Ricardo Griffith on 17/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import UIKit

class MeMeTableViewController: UITableViewController {
    // MARK: Globals
    var applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    // MARK: Actions
    
    // dismiss the current view to display the construct Meme scene.
    @IBAction func addMeme(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MemeScene") as! MemeEditorViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: Overrides
    // Asks the data source to commit the insertion or deletion of a specified row in the receiver.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            applicationDelegate.memes.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    // Notifies the view controller that its view is about to be added to a view hierarchy.
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    
    // Notifies the view controller that its view was added to a view hierarchy.
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        load()
    }
    
    // Tells the data source to return the number of rows in a given section of a table view.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applicationDelegate.memes.count
    }
    
    // Asks the data source for a cell to insert in a particular location of the table view.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell")
        let meme = applicationDelegate.memes[indexPath.row]
        
        // Populate the object with data.
        cell!.textLabel?.text = "\(meme.topString)...\(meme.bottomString)"
        cell!.imageView?.image = meme.memeImage
        
        return cell!
    }
    
    // Tells the delegate that the specified row is now selected.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewControllerWithIdentifier("details") as! MemeDetailedController
        
        let meme = applicationDelegate.memes[indexPath.row]
        nextViewController.meme = meme
        
        navigationController?.pushViewController(nextViewController, animated: true)
        //presentViewController(nextViewController, animated: true, completion: nil)
    }
    
    // MARK: Data Functions
    // Refreshes the data in the table view.
    func load() {
        // Centralized model
        tableView.reloadData()
    }
}
