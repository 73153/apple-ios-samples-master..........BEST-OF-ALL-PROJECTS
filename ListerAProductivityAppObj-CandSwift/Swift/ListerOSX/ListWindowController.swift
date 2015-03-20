/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    
                The `ListWindowController` class is a window controller that displays a single list document. It also handles interaction with the "share" button and the "plus" button (for creating a new item).
            
*/

import Cocoa
import ListerKitOSX

class ListWindowController: NSWindowController {
    // MARK: Types
    
    struct SegueIdentifiers {
        static let showAddItemViewController = "showAddItemViewController"
    }
    
    // MARK: IBOutlets

    @IBOutlet weak var shareButton: NSButton!
    
    // MARK: View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        let action = Int(NSEventMask.LeftMouseDownMask.rawValue)
        shareButton.sendActionOn(action)
    }

    // MARK: Overrides
    
    override var document: AnyObject? {
        didSet {
            let listViewController = window!.contentViewController as ListViewController
            listViewController.document = document as? ListDocument
        }
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.showAddItemViewController {
            let listViewController = window!.contentViewController as ListViewController

            let addItemViewController = segue.destinationController as AddItemViewController

            addItemViewController.delegate = listViewController
        }
    }
    
    // MARK: IBActions

    @IBAction func shareDocument(sender: NSButton) {
        if let listDocument = document as? ListDocument {
            let listContents = ListFormatting.stringFromListItems(listDocument.list.items)
            
            let sharingServicePicker = NSSharingServicePicker(items: [listContents])
            
            let preferredEdge =  NSRectEdge(CGRectEdge.MinYEdge.rawValue)
            sharingServicePicker.showRelativeToRect(NSZeroRect, ofView: sender, preferredEdge: preferredEdge)
        }
    }
}
