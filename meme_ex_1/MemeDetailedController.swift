//
//  MemeDetailedController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 19/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import UIKit

class MemeDetailedController: UIViewController {
    // MARK: Globals
    var meme : Meme?
    var removalIndex : Int = 0
    
    @IBOutlet weak var memedPhoto: UIImageView!

    // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        memedPhoto.image = meme?.memeImage
        memedPhoto.contentMode = UIViewContentMode.ScaleAspectFill
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "edit")
    }
    
    // Loads the Meme editor
    func edit() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MemeScene") as! MemeEditorViewController
        vc.isEdit = true
        vc.memeToEdit = meme
        vc.removalIndex = removalIndex
        presentViewController(vc, animated: true, completion: nil)
    }
}