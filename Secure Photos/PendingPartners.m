//
//  PendingPartners.m
//  Secure Photos
//
//  Created by Taylor Wright-Sanson on 11/2/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "PendingPartners.h"
#import <Parse/PFObject+Subclass.h>

@implementation PendingPartners

@dynamic user;
@dynamic partnersEmail;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"PendingPartners";
}

- (PFUser *)user
{
    return [self objectForKey:@"user"];
}

- (NSString *)partnersEmail
{
    return [self objectForKey:@"partnersEmail"];
}

@end
