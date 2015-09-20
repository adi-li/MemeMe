//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Adi Li on 20/9/15.
//  Copyright © 2015 Adi Li. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    var selectedMemeIndexes = Set<Int>()
    
    // Two outlets below are not weak reference because they will be released if I removed them from `navigationItem`
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    lazy var doneEditButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneEditing:")
    }()
    lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "batchDelete:")
        button.tintColor = UIColor.redColor()
        return button
    }()
    
    // MARK: UIViewController
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
        editButton.enabled = memes.count > 0
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeTableViewCell

        cell.meme = memes[indexPath.row]

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.editing {
            // In editing mode, no need to go to detail view
            selectedMemeIndexes.insert(indexPath.row)
            return
        }
        
        // Normal mode
        let detailVC = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailViewController
        
        detailVC.memeIndex = indexPath.row
        
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.editing {
            selectedMemeIndexes.remove(indexPath.row)
            return
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - Bulk edit
    
    @IBAction func editTable(sender: UIBarButtonItem) {
        // Prevent the the table view is already in editing as the user is editing a row
        tableView.editing = false
        
        // Reset selected meme indexes
        selectedMemeIndexes.removeAll()
        
        // Update editing view
        tableView.setEditing(true, animated: true)
        navigationItem.leftBarButtonItem = deleteButton
        navigationItem.rightBarButtonItem = doneEditButton
    }
    
    func doneEditing(sender: UIBarButtonItem) {
        tableView.setEditing(false, animated: true)
        navigationItem.leftBarButtonItem = editButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    func batchDelete(sender: UIBarButtonItem) {
        tableView.beginUpdates()
        
        // remove selected meme from memes
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var newMemes = [Meme]()
        for (idx, meme) in appDelegate.memes.enumerate() {
            if selectedMemeIndexes.contains(idx) {
                continue
            }
            newMemes.append(meme)
        }
        
        appDelegate.memes = newMemes
        
        // remove all selected table view cells
        var indexPaths = [NSIndexPath]()
        for idx in selectedMemeIndexes {
            indexPaths.append(NSIndexPath(forRow: idx, inSection: 0))
        }
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)

        tableView.endUpdates()
    }
}
