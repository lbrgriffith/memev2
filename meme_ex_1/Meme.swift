//
//  Meme.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 10/02/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    //  representing the top and bottom text
    var topString: String
    var bottomString : String
    // the original image
    var OriginalImage : UIImage
    // a memed image, combining the text and the original image
    var MemeImage : UIImage
    
    static func encode(meme: Meme) {
        let memeClassObject = MemeHelperClass(meme: meme)
        
        NSKeyedArchiver.archiveRootObject(memeClassObject, toFile: MemeHelperClass.path())
    }
    
    static func decode() -> Meme? {
        let memeClassObject = NSKeyedUnarchiver.unarchiveObjectWithFile(MemeHelperClass.path()) as? MemeHelperClass
        
        return memeClassObject?.meme
    }
}

// Adds a class within the Meme struct that conforms to 
// NSCoding as the data persistence mechanism.
extension Meme {
    class MemeHelperClass: NSObject, NSCoding {
        
        var meme: Meme?
        
        init(meme: Meme) {
            self.meme = meme
            super.init()
        }
        
        class func path() -> String {
            let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
            let path = documentsPath?.stringByAppendingString("/savedMemes")
            return path!
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard let topString = aDecoder.decodeObjectForKey("topString") as? String else { meme = nil; super.init(); return nil }
            guard let bottomString = aDecoder.decodeObjectForKey("bottomString") as? String else { meme = nil; super.init(); return nil }
            guard let originalImage = aDecoder.decodeObjectForKey("originalImage") as? UIImage else { meme = nil; super.init(); return nil }
            guard let memeImage = aDecoder.decodeObjectForKey("memeImage") as? UIImage else { meme = nil; super.init(); return nil }
            
            meme = Meme(topString: topString, bottomString: bottomString, OriginalImage: originalImage, MemeImage: memeImage)
            
            super.init()
        }
        
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(meme!.topString, forKey: "topString")
            aCoder.encodeObject(meme!.bottomString, forKey: "bottomString")
            aCoder.encodeObject(meme!.OriginalImage, forKey: "originalImage")
            aCoder.encodeObject(meme!.MemeImage, forKey: "memeImage")
        }
    }
}