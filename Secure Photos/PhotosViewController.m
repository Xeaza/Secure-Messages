//
//  PhotosViewController.m
//  Secure Photos
//
//  Created by Taylor Wright-Sanson on 10/31/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "PhotosViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "RNDecryptor.h"
#import "RNEncryptor.h"
#import "PhotosTableViewCell.h"
#import "ColorUtils.h"
#import <Parse/Parse.h>

@interface PhotosViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *photos;
@property (copy, nonatomic) NSString *filePath;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL colorSwap;

@end

@implementation PhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    [self setupUserDirectory];
    [self prepareData];
    self.colorSwap = YES;
}

- (void)setupUserDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    self.filePath = [documents stringByAppendingPathComponent:self.username];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:self.filePath]) {
        NSLog(@"Directory already present.");

    } else {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:self.filePath withIntermediateDirectories:YES attributes:nil error:&error];

        if (error) {
            NSLog(@"Unable to create directory for user.");
        }
    }
}

- (void)prepareData
{
    self.photos = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error = nil;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:self.filePath error:&error];

    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error) {
             NSLog(@"Error: %@", error.userInfo);
         }
         else {
             PFObject *message = objects.firstObject;
             PFFile *userImageFile = message[@"imageFile"];
             [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                 if (error) {
                     NSLog(@"Error getting secure image data %@", error);
                 }
                 else
                 {
                     NSData *decryptedData = [RNDecryptor decryptData:imageData withSettings:kRNCryptorAES256Settings password:@"A_SECRET_PASSWORD" error:nil];
                     UIImage *image = [UIImage imageWithData:decryptedData];
                     [self.photos addObject:image];
                     [self.tableView reloadData];
                 }
             }];
         }
     }];

    /* // Code to get Images from File System
    if ([contents count] && !error){
        NSLog(@"Contents of the user's directory. %@", contents);

        for (NSString *fileName in contents) {
            if ([fileName rangeOfString:@".securedData"].length > 0) {
                NSData *data = [NSData dataWithContentsOfFile:[self.filePath stringByAppendingPathComponent:fileName]];
                NSData *decryptedData = [RNDecryptor decryptData:data withSettings:kRNCryptorAES256Settings password:@"A_SECRET_PASSWORD" error:nil];
                UIImage *image = [UIImage imageWithData:decryptedData];
                [self.photos addObject:image];

            } else {
                NSLog(@"This file is not secured.");
            }
        }

    } else if (![contents count]) {
        if (error) {
            NSLog(@"Unable to read the contents of the user's directory.");
        } else {
            NSLog(@"The user's directory is empty.");
        }
    }
     */
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < 2)
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;

        if (buttonIndex == 0)
        {
            #if TARGET_IPHONE_SIMULATOR

            #else
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            #endif

        } else if ( buttonIndex == 1) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }

        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];

    if (!image) {
        [info objectForKey: UIImagePickerControllerOriginalImage];
    }

    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *imageName = [NSString stringWithFormat:@"image-%lu.securedData", self.photos.count + 1];
    NSData *encryptedImage = [RNEncryptor encryptData:imageData withSettings:kRNCryptorAES256Settings password:@"A_SECRET_PASSWORD" error:nil];
    [encryptedImage writeToFile:[self.filePath stringByAppendingPathComponent:imageName] atomically:YES];

    PFFile *messageFile = [PFFile fileWithData:encryptedImage];

    PFObject *message = [PFObject objectWithClassName:@"Message"];
    message[@"imageName"] = @"Super Secrete Stuff!";
    message[@"imageFile"] = messageFile;

    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.userInfo);
        }
        else {
            NSLog(@"Encrypted Image Uploaded");
        }
    }];

//    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error.userInfo);
//        }
//        else {
//            NSLog(@"Encrypted Image Uploaded");
//        }
//    } progressBlock:^(int percentDone) {
//        NSLog(@"Percent uploaded: %d", percentDone);
//
//    }];

    [self.photos addObject:image];
    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count; //self.photos ? self.photos.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (self.colorSwap)
    {
        cell.backgroundColor = [UIColor colorWithString:@"3579AA"];
        self.colorSwap = NO;
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithString:@"36AA95"];
        self.colorSwap = YES;
    }
    cell.secretImage.image = [self.photos objectAtIndex:indexPath.row];

    return cell;
}

- (IBAction)onTakePhotoButtonPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
