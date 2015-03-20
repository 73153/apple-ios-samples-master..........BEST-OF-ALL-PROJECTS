/*
     Copyright (C) 2014 Apple Inc. All Rights Reserved.
     See LICENSE.txt for this sample’s licensing information
     
     Abstract:
     
                  The view controller responsible for displaying the contents of a list document.
              
 */

@import Cocoa;
#import "AAPLAddItemViewController.h"

@class AAPLListItem, AAPLListDocument;

@interface AAPLListViewController : NSViewController <AAPLAddItemViewControllerDelegate>

@property (nonatomic, weak) AAPLListDocument *document;

@end
