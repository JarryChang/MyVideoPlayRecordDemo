//
//  PlayVideoViewController.m
//  MyVideoPlayRecord
//
//  Created by chang on 14-3-23.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import "PlayVideoViewController.h"

@interface PlayVideoViewController ()

@end

@implementation PlayVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PlayVideo:(id)sender {
    
    [self startMediaBrowserFromViewController:self usingDelegate:self];
    
}


-(BOOL)startMediaBrowserFromViewController:(UIViewController *)controller usingDelegate:(id)delegate{
    //1 - Validations
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]==NO || (delegate==nil) || (controller==nil)) {
        return NO;
    }

    //2 - Get image picker
    UIImagePickerController * mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    // Hides the controls for moving & scaing pictures, or for
    // trimming movies.To instead show the controls,use YES
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    
    // 3 - Display image picker
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}



@end




































