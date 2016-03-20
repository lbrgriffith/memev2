//
//  CustomMemeCell.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 19/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import Foundation
import UIKit

// desired meme display
class CustomMemeCell : UICollectionViewCell {
    var meme : Meme?
    @IBOutlet weak var memedImage: UIImageView!
}