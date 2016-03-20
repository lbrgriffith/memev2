//
//  MemeDetailedController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 19/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailedController: UIViewController {
    // MARK: Globals
    var meme : Meme?
    @IBOutlet weak var memedPhoto: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        memedPhoto.image = meme?.memeImage
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func editMeme(sender: UIBarButtonItem) {
        
    }
}