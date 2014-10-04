//
//  MergeVideoViewController.m
//  MyVideoPlayRecord
//
//  Created by chang on 14-3-23.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import "MergeVideoViewController.h"

@interface MergeVideoViewController ()

@end

@implementation MergeVideoViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loadAssetOne:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]==NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Saved Album Found"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
       
        isSelectingAssetOne = true;
        [self startMediaBrowserFromViewController:self usingDelegate:self];
    }
}

- (IBAction)loadAssetTwo:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]==NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Saved Album Found"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        
        isSelectingAssetOne = false;
        [self startMediaBrowserFromViewController:self usingDelegate:self];
    }
}

- (IBAction)loadAudio:(id)sender {
    
    MPMediaPickerController * mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
    mediaPicker.delegate = self;
    mediaPicker.prompt = @"Select Audio";
    [self presentViewController:mediaPicker animated:YES completion:nil];
    
}

- (IBAction)mergeAndSave:(id)sender {
    
    if (_firstAsset !=nil && _secondAsset !=nil) {
        [_activityView startAnimating];
        // 1 - Create AVMutableComposition object.This object willhold your
        // AVMutableCompositionTrack instance
        AVMutableComposition * mixComposition = [[AVMutableComposition alloc] init];
//        // 2 - Video track
//        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, _firstAsset.duration) ofTrack:[[_firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
//         [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, _secondAsset.duration) ofTrack:[[_secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        // 2 - Create two video tracks
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, _firstAsset.duration)
                            ofTrack:[[_firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                             preferredTrackID:kCMPersistentTrackID_Invalid];
        [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, _secondAsset.duration)
                             ofTrack:[[_secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:_firstAsset.duration error:nil];
        
        
        
        // 2.1 - Create AVMutableVideoCompositionInstruction
        AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(_firstAsset.duration, _secondAsset.duration));
        // 2.2 - Create an AVMutableVideoCompositionLayerInstruction for the first track
        AVMutableVideoCompositionLayerInstruction *firstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        AVAssetTrack *firstAssetTrack = [[_firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation firstAssetOrientation_  = UIImageOrientationUp;
        BOOL isFirstAssetPortrait_  = NO;
        CGAffineTransform firstTransform = firstAssetTrack.preferredTransform;
        if (firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0) {
            firstAssetOrientation_ = UIImageOrientationRight;
            isFirstAssetPortrait_ = YES;
        }
        if (firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0) {
            firstAssetOrientation_ =  UIImageOrientationLeft;
            isFirstAssetPortrait_ = YES;
        }
        if (firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0) {
            firstAssetOrientation_ =  UIImageOrientationUp;
        }
        if (firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {
            firstAssetOrientation_ = UIImageOrientationDown;
        }
        [firstlayerInstruction setTransform:_firstAsset.preferredTransform atTime:kCMTimeZero];
        [firstlayerInstruction setOpacity:0.0 atTime:_firstAsset.duration];
        // 2.3 - Create an AVMutableVideoCompositionLayerInstruction for the second track
        AVMutableVideoCompositionLayerInstruction *secondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        AVAssetTrack *secondAssetTrack = [[_secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation secondAssetOrientation_  = UIImageOrientationUp;
        BOOL isSecondAssetPortrait_  = NO;
        CGAffineTransform secondTransform = secondAssetTrack.preferredTransform;
        if (secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0) {
            secondAssetOrientation_= UIImageOrientationRight;
            isSecondAssetPortrait_ = YES;
        }
        if (secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0) {
            secondAssetOrientation_ =  UIImageOrientationLeft;
            isSecondAssetPortrait_ = YES;
        }
        if (secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0) {
            secondAssetOrientation_ =  UIImageOrientationUp;
        }
        if (secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {
            secondAssetOrientation_ = UIImageOrientationDown;
        }
        [secondlayerInstruction setTransform:_secondAsset.preferredTransform atTime:_firstAsset.duration];
        
        // 2.4 - Add instructions
        mainInstruction.layerInstructions = [NSArray arrayWithObjects:firstlayerInstruction, secondlayerInstruction,nil];
        AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
        mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
        mainCompositionInst.frameDuration = CMTimeMake(1, 30);
        
        CGSize naturalSizeFirst, naturalSizeSecond;
        if(isFirstAssetPortrait_){
            naturalSizeFirst = CGSizeMake(firstAssetTrack.naturalSize.height, firstAssetTrack.naturalSize.width);
        } else {
            naturalSizeFirst = firstAssetTrack.naturalSize;
        }
        if(isSecondAssetPortrait_){
            naturalSizeSecond = CGSizeMake(secondAssetTrack.naturalSize.height, secondAssetTrack.naturalSize.width);
        } else {
            naturalSizeSecond = secondAssetTrack.naturalSize;
        }
        
        float renderWidth, renderHeight;
        if(naturalSizeFirst.width > naturalSizeSecond.width) {
            renderWidth = naturalSizeFirst.width;
        } else {
            renderWidth = naturalSizeSecond.width;
        }
        if(naturalSizeFirst.height > naturalSizeSecond.height) {
            renderHeight = naturalSizeFirst.height;
        } else {
            renderHeight = naturalSizeSecond.height;
        }
        mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
  
        
        
        
        
        // 3 - Audio track
        if (_audioAsset !=nil) {
            AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(_firstAsset.duration, _secondAsset.duration)) ofTrack:[[_audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            
        }
        
        // 4 -Get path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() %1000]];
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        // 5 -Create exporter
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL = url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self exportDidFinish:exporter];
            });
        }];
        
        
    }
    
    
}


-(BOOL)startMediaBrowserFromViewController:(UIViewController *)controller usingDelegate:(id)delegate{

    // 1 - Validation
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]==NO)||(delegate==nil)||(controller ==nil)) {
        return NO;
    }
    
    // 2 - Create image picker
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    // Hides the controls for moving & sacling pictures,or for
    // trimming movies.To instead show the controls,use YES.
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    
    // 3 -Display image picker
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;

}

-(void)imagePickController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{


    // 1 -Get media type
    NSString * mediaType = (NSString *)[info objectForKey:UIImagePickerControllerMediaType];
    
    // 2 - Dismiss image picker
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // 3 - Handle video selection
    if (CFStringCompare((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0)==kCFCompareEqualTo) {
        if (isSelectingAssetOne) {
            NSLog(@"Video One Loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded"
                                                            message:@"Video One Loaded"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }else{
            NSLog(@"Video Two Loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded"
                                                            message:@"Video Two Loaded"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        
        }
    }


}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
   
    NSArray *selectedSong = [mediaItemCollection items];
    if ([selectedSong count]>0) {
        MPMediaItem *songItem = [selectedSong objectAtIndex:0];
        NSURL *songURL = [songItem valueForProperty:MPMediaItemPropertyAssetURL];
        _audioAsset = [AVAsset assetWithURL:songURL];
        NSLog(@"Audio Loaded");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Audio Loaded" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }

    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)exportDidFinish:(AVAssetExportSession *)session{
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                });
            }];
        }
    }
    _audioAsset = nil;
    _firstAsset = nil;
    _secondAsset = nil;
    [_activityView stopAnimating];

}

@end







































