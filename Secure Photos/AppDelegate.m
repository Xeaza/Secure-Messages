//
//  AppDelegate.m
//  Secure Photos
//
//  Created by Taylor Wright-Sanson on 10/31/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AppDelegate *applicationDeleagte = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [applicationDeleagte setNavigationController:self.navigationController];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
