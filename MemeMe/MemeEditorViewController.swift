//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Adi Li on 6/9/15.
//  Copyright (c) 2015 Adi Li. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var currentEditingTextField: UITextField?
    var meme: Meme?
    
    // MARK: - Override UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default text attributes
        let textAttributes = getDefaultTextAttributes()
        
        topTextField.defaultTextAttributes = textAttributes
        bottomTextField.defaultTextAttributes = textAttributes
        
        // Set placeholders for text field
        topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: textAttributes)
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: textAttributes)
        
        // Reset image and text
        resetImage(nil, andText: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        // Only enable camera button if camera exists
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Reset data
    func resetImage(image: UIImage?, andText resetText: Bool = false) {
        meme = nil
        imageView.image = image
        
        // Only enable share button if image present
        shareButton.enabled = (image != nil)
        
        if resetText {
            topTextField.text = ""
            bottomTextField.text = ""
        }
    }
    
    @IBAction func cancelChange(sender: UIBarButtonItem) {
        resetImage(nil, andText: true)
    }
    
    func getDefaultTextAttributes() -> [NSObject: AnyObject] {
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .ByTruncatingTail
        paragraphStyle.alignment = .Center
        return [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -5,
        ]
    }
    
    // MARK: - Importing image
    func importPhotoFromSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = sourceType
        imagePickerVC.delegate = self
        
        presentViewController(imagePickerVC, animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        importPhotoFromSourceType(.Camera)
    }
    
    @IBAction func pickPhoto(sender: UIBarButtonItem) {
        importPhotoFromSourceType(.PhotoLibrary)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        var image: UIImage?
        
        // Get image from edited image or original image
        let keyChains = [UIImagePickerControllerEditedImage, UIImagePickerControllerOriginalImage]
        
        for key in keyChains {
            image = info[key] as? UIImage
            if image != nil {
                break
            }
        }
        
        // Reset with image
        resetImage(image)
        
        // Dismiss the picker
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Text editing
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        currentEditingTextField = textField
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // dismiss the keyboard
        textField.resignFirstResponder()
        currentEditingTextField = nil
        return true
    }
    
    // MARK: - Keyboard notifications handling
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let textField = currentEditingTextField {
            if textField == bottomTextField {
                view.frame.origin.y = -getKeyboardHeight(notification)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // MARK: - Saving Meme
    
    func generateMemedImage() -> UIImage {
        // Hide navbar and toolbar
        navigationBar.hidden = true
        toolbar.hidden = true
        
        // Snapshot the view as image
        let memedImage = UIImage.fromView(view, afterScreenUpdates: true)
        
        // Show navbar and toolbar
        navigationBar.hidden = false
        toolbar.hidden = false
        
        return memedImage
    }
    
    func saveMemeWithImage(memedImage: UIImage) {
        if let image = imageView.image {
            let topText = topTextField.text != nil ? topTextField.text : "TOP"
            let bottomText = bottomTextField.text != nil ? bottomTextField.text : "BOTTOM"
            meme = Meme(topText: topText, bottomText: bottomText, image: image, memedImage: memedImage)
        }
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { [weak self]
            (activityType: String!, completed: Bool, items: [AnyObject]!, error: NSError!) in
            
            if completed {
                self?.saveMemeWithImage(memedImage)
            }
            
        }
        presentViewController(activityVC, animated: true, completion: nil)
    }

}

