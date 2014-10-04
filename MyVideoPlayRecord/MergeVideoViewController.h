//
//  MergeVideoViewController.h
//  MyVideoPlayRecord
//
//  Created by chang on 14-3-23.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>


@interface MergeVideoViewController : UIViewController<MPMediaPickerControllerDelegate>
{
    BOOL isSelectingAssetOne;
}
@property(nonatomic,strong) AVAsset *firstAsset;
@property(nonatomic,strong) AVAsset *secondAsset;
@property(nonatomic,strong) AVAsset * audioAsset;
@property(weak,nonatomic) IBOutlet UIActivityIndicatorView *activityView;

- (IBAction)loadAssetOne:(id)sender;
- (IBAction)loadAssetTwo:(id)sender;
- (IBAction)loadAudio:(id)sender;
- (IBAction)mergeAndSave:(id)sender;

-(BOOL)startMediaBrowserFromViewController:(UIViewController *)controller usingDelegate:(id)delegate;
-(void)exportDidFinish:(AVAssetExportSession *)session;


@end
