//
//  PendingPartners.h
//  Secure Photos
//
//  Created by Taylor Wright-Sanson on 11/2/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PendingPartners : PFObject <PFSubclassing>

@property PFUser *user;
@property NSString *partnersEmail;

@end
