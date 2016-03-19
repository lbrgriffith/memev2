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
    
    @IBOutlet weak var MemeImageUIImageView: UIImageView!
    @IBOutlet weak var topStringUILabel: UILabel!
    @IBOutlet weak var bottomStringUILabel: UILabel!
    
    func setText(top: String, bottomString: String) {
        topStringUILabel.text = top
        bottomStringUILabel.text = bottomString
    }
}