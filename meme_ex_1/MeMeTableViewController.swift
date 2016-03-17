//
//  MeMeTableViewController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 17/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import Foundation
import UIKit

class MeMeTableViewController: UITableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        return cell!
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
