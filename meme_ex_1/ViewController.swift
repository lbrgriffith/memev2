//
//  ViewController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 19/01/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Text attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0]
        
        // Apply attributes to textFields
        textTop.defaultTextAttributes = memeTextAttributes
        textBottom.defaultTextAttributes = memeTextAttributes
        // Align text.
        textTop.textAlignment = NSTextAlignment.Center
        textBottom.textAlignment = NSTextAlignment.Center
        
        textBottom.delegate = self
        textTop.delegate = self
        shareButton.enabled = false
    }
    
    @IBAction func share(sender: AnyObject) {
        let activityItem: [AnyObject] = [save().MemeImage as AnyObject]
        
        let activityView = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
        
        self.presentViewController(activityView, animated: true, completion: nil)
    }
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // generate a memed image
    func generateMemedImage() -> UIImage
    {
        // Hide toolbar and navbar
        navigationController?.navigationBarHidden = true
        bottomToolBar.hidden = true
        shareButton.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navigationController?.navigationBarHidden = false
        bottomToolBar.hidden = false
        shareButton.hidden = false
        
        return memedImage
    }
    
    func save() -> Meme {
        // initializes a Meme model object.
        return Meme(topString: textTop.text!, bottomString: textBottom.text!, OriginalImage:imagePicked.image!, MemeImage: generateMemedImage())
    }
    
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func subscribeToKeyboardHidingNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardHidingNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    @IBAction func pickImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePicked.image = image
            shareButton.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == textBottom {
            self.subscribeToKeyboardNotifications()
            self.subscribeToKeyboardHidingNotifications()
        }
        if textField.text == "TOP" {
            textField.text = ""
        }
        if textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == textBottom {
            self.unsubscribeFromKeyboardNotifications()
            self.unsubscribeFromKeyboardHidingNotifications()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

