//
//  RecordVideoViewController.h
//  MyVideoPlayRecord
//
//  Created by chang on 14-3-23.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RecordVideoViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

- (IBAction)RecordAndPlay:(id)sender;
-(BOOL)startCameraControllerFromViewController:(UIViewController *)controller usingDelegate:(id)delegate;
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;


@end
