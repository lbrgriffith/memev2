//
//  ViewController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 19/01/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    // MARK: Globals
    
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let defaultBottomText = "BOTTOM"
    let defaultTopText = "TOP"
    
    var isEdit : Bool = false
    var memeToEdit : Meme? = nil
    let appDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate

    // MARK: Controller Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTextField(textTop)
        styleTextField(textBottom)
        
        if isEdit {
            if (memeToEdit != nil) {
                textTop.text = memeToEdit?.topString
                textBottom.text = memeToEdit?.bottomString
                imagePicked.image = memeToEdit?.originalImage
            }
        } else {
            // Disable the share button.
            shareButton.enabled = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Only allow the camera option if the device supports it.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    // Notifies the view controller that its view is about to be removed from a view hierarchy.
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SentTableView") as! MeMeTableViewController
        vc.load()
        
        appDelegate.saveMemes()
        
        if isEdit {
            self.presentingViewController?.dismissViewControllerAnimated(false, completion: {})
            }
    }
    
    // MARK: Actions
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        // Back to initial state...
        textBottom.text = defaultBottomText
        textTop.text = defaultTopText
        imagePicked.image = nil

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func share(sender: AnyObject) {
        // Get the current MemeImage
        let activityItem: [AnyObject] = [generateMemedImage() as AnyObject]
        
        // Show the Activity View to allow the user to share this Meme.
        let activityView = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
        presentViewController(activityView, animated: true, completion: save)
    }
    
    // Allow the user to select an image.
    @IBAction func pickImage(sender: AnyObject) {
        pickPhotoBySource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    // Allow the user to select an image from the device's album
    @IBAction func pickAnImageFromAlbum (sender: AnyObject) {
        pickPhotoBySource(UIImagePickerControllerSourceType.Camera)
    }
    
    func pickPhotoBySource(source : UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func save() {
        // initializes a Meme model object.
        let unsavedMeme = Meme(top: textTop.text!, bottom: textBottom.text!, originalPhoto:imagePicked.image!, memePhoto: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        appDelegate.memes.append(unsavedMeme!)
    }

    // MARK: NOTIFICATION
    
    // Calcuate and return the size of the keyboard.
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
        topToolBar.hidden = true
        
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
        topToolBar.hidden = false
        
        return memedImage
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
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

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Check if image is selected.
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePicked.image = image
            shareButton.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: TextField Methods
    
    func styleTextField(textField : UITextField) {
        // Text attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0]
        
        // Apply attributes to textFields
        textField.defaultTextAttributes = memeTextAttributes
        
        // Align text.
        textField.textAlignment = NSTextAlignment.Center
        
        // Set the textFields delegate to this class.
        textField.delegate = self
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Enable notifications only if the bottom textbox is being edited.
        if textField == textBottom {
            self.subscribeToKeyboardNotifications()
            self.subscribeToKeyboardHidingNotifications()
        }
        // remove the text if = to TOP or BOTTOM initial text.
        if textField.text == defaultTopText {
            textField.text = ""
        }
        if textField.text == defaultBottomText {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Remember to remove the observers if done editing bottom text.
        if textField == textBottom {
            self.unsubscribeFromKeyboardNotifications()
            self.unsubscribeFromKeyboardHidingNotifications()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // dismiss the keyboard when user presses the return/done button.
        textField.resignFirstResponder()
        return true
    }
}

