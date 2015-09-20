//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Adi Li on 20/9/15.
//  Copyright © 2015 Adi Li. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController, UIAlertViewDelegate {
    
    var memeIndex: Int!
    var meme: Meme! {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes[memeIndex]
    }
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set image from meme
        memeImageView.image = meme.memedImage
        
        // Set edit / delete buttons
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "askForDeleteMeme:")
        deleteButton.tintColor = UIColor.redColor()
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editMeme:"),
            deleteButton
        ]
    }
    
    // MARK: - Edit meme
    
    func editMeme(sender: UIBarButtonItem) {
        let editor = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC") as! MemeEditorViewController
        
        // Launch editor with selected meme data
        editor.editingMemeIndex = memeIndex
        
        presentViewController(editor, animated: true, completion: nil)
    }
    
    // MARK: - Delete meme
    
    func askForDeleteMeme(sender: UIBarButtonItem) {
        UIAlertView(title: "Delete Meme", message: "Are you sure to delete this meme?",
            delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes").show()
    }
    
    func deleteMeme() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.memes.removeAtIndex(memeIndex)
        
        navigationController!.popViewControllerAnimated(true)
    }
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            deleteMeme()
        }
    }
}
