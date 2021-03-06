//
//  ViewController.m
//  Secure Photos
//
//  Created by Taylor Wright-Sanson on 10/31/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "ViewController.h"
#import "SSKeychain.h"
#import "AppDelegate.h"
#import "PhotosViewController.h"
#import <Parse/Parse.h>

@interface ViewController () <UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{

    // TODO
    // Get login scren to send email to partner
    // Make a second screen where user can add the email of their partner
    // Make that send an email inviting the partner to signup.
    // Connect the two partners online when the user signs up
    // https://www.parse.com/questions/connect-with-a-single-user-via-email

    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"The current user is: %@", currentUser.username);
        //[self.tabBarController.tabBar setHidden:NO];
        //[self getMyfollowersImages];

    }
    else {
        [self performSegueWithIdentifier:@"ShowLoginSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)onLoginButtonPressed:(id)sender
{
    if (self.usernameTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        NSString *password = [SSKeychain passwordForService:@"MyPhotos" account:self.usernameTextField.text];

        if (password.length > 0) {
            if ([self.passwordTextField.text isEqualToString:password]) {
                [self performSegueWithIdentifier:@"photosViewController" sender:nil];

            } else {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error Login" message:@"Invalid username/password combination." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }

        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Account" message:@"Do you want to create an account?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alertView show];
        }

    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Input" message:@"Username and/or password cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self createAccount];
            break;
        default:
            break;
    }
}

- (void)createAccount
{
    BOOL result = [SSKeychain setPassword:self.passwordTextField.text forService:@"MyPhotos" account:self.usernameTextField.text];

    if (result) {
        [self performSegueWithIdentifier:@"photosViewController" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PhotosViewController *photosViewController = segue.destinationViewController;
    //photosViewController.username = self.usernameTextField.text;
    self.passwordTextField.text = nil;
}


@end
