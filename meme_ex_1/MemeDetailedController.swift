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
    var meme : UIImage?
    @IBOutlet weak var memedPhoto: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        memedPhoto.image = meme
    }
}