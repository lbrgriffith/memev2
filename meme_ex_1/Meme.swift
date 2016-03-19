//
//  Meme.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 10/02/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import Foundation
import UIKit

//** Meme class ready for encoding.  
class Meme: NSObject, NSCoding {
    // MARK: Properties
    
    //** Representing the top Meme text */
    var topString: String
    //** Representing the bottom Meme text */
    var bottomString : String
    //** The original image */
    var originalImage : UIImage
    //** A memed image, combining the text and the original image */
    var memeImage : UIImage
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("memes")
    
    // MARK: Types
    
    struct PropertyKey {
        static let topKey = "top"
        static let bottomKey = "bottom"
        static let originalKey = "original"
        static let memeKey = "meme"
    }
    
    // MARK: Initialization
    
    init?(top: String, bottom: String, originalPhoto: UIImage?, memePhoto: UIImage?) {
        // Initialize stored properties.
        self.topString = top
        self.bottomString = bottom
        self.originalImage = originalPhoto!
        self.memeImage = memePhoto!
        
        super.init()
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(topString, forKey: PropertyKey.topKey)
        aCoder.encodeObject(bottomString, forKey: PropertyKey.bottomKey)
        aCoder.encodeObject(originalImage, forKey: PropertyKey.originalKey)
        aCoder.encodeObject(memeImage, forKey: PropertyKey.memeKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let top = aDecoder.decodeObjectForKey(PropertyKey.topKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.originalKey) as? UIImage
        let memePhoto = aDecoder.decodeObjectForKey(PropertyKey.memeKey) as? UIImage
        
        let bottom = aDecoder.decodeObjectForKey(PropertyKey.bottomKey) as! String
        
        // Must call designated initializer.
        self.init(top: top, bottom:bottom, originalPhoto: photo, memePhoto: memePhoto)
    }
    
}