//
//  MeMeTabBarController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 19/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import UIKit

class MeMeTabBarController : UITabBarController {
    // MARK: Overrides
    override func viewDidLoad() {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        if (applicationDelegate.loadMemes() != nil) {
            applicationDelegate.memes = applicationDelegate.loadMemes()!
        }
    }
}