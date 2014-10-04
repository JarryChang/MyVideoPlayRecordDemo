//
//  RecordVideoViewController.m
//  MyVideoPlayRecord
//
//  Created by chang on 14-3-23.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import "RecordVideoViewController.h"

@interface RecordVideoViewController ()

@end

@implementation RecordVideoViewController

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


- (IBAction)RecordAndPlay:(id)sender {
    
    [self startCameraControllerFromViewController:self usingDelegate:self];
}


-(BOOL)startCameraControllerFromViewController:(UIViewController *)controller usingDelegate:(id)delegate{

    //1 -Validattions
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ==NO)||(delegate==nil)||(controller==nil)) {
        return NO;
    }
    
    //2 -Get image picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures,or for
    // trimming movies.To instead show the controls,user YES
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    
    // 3- Display image picker
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
    
}

-(void)imageOickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaMetadata];
    [self dismissViewControllerAnimated:NO completion:nil];
    //Handle a movie capture
    if (CFStringCompare((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0)==kCFCompareEqualTo) {
        NSString *moviePath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }

}

-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{

    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Video Saving Failed"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved"
                                                        message:@"Saved To Photo Album"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    
    }

}




@end







































































