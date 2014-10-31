//
//  PhotosViewController.h
//  Secure Photos
//
//  Created by Taylor Wright-Sanson on 10/31/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosViewController : UICollectionViewController

@property (copy, nonatomic) NSString *username;

- (IBAction)photo:(id)sender;

@end