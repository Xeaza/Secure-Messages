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

@interface ViewController () <UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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


@end
