//
//  PlayVideoViewController.h
//  MyVideoPlayRecord
//
//  Created by chang on 14-3-23.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>


@interface PlayVideoViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


// For opening UIImagePickerController
-(BOOL)startMediaBrowserFromViewController:(UIViewController *)controller usingDelegate:(id)delegate;
- (IBAction)PlayVideo:(id)sender;

@end
