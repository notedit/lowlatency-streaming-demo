//
//  ViewController.m
//  avlittle
//
//  Created by xiang on 12/06/2018.
//  Copyright © 2018 dotEngine. All rights reserved.
//

#import "ViewController.h"

#import <TXLivePush.h>
#import <TXLivePlayer.h>
#import <TXLiveSDKTypeDef.h>




@interface ViewController () <TXLivePushListener, TXLivePlayListener>
{
    TXLivePush* pusher;
    TXLivePlayer* player;
    
    UIView*   pusherView;
    UIView*   playerView;
    
    NSString*  pushUrl;
    NSString* playUrl;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    // random a pushUrl
    
    pushUrl = @"rtmp://19251.livepush.myqcloud.com/live/stream2?bizid=19251&txSecret=44a6b19bce12aea4e7ade7b0dfbdd834&txTime=5CC870FF";
    
    NSLog(pushUrl);
    
    TXLivePushConfig *pushconfig = [[TXLivePushConfig alloc] init];
    pushconfig.enableAEC = TRUE;
    pushconfig.videoEncodeGop = 2;
    pushconfig.touchFocus = FALSE;
    pushconfig.videoFPS = 10;
    pushconfig.frontCamera=FALSE;
    pushconfig.enableAutoBitrate = TRUE;
    pushconfig.autoAdjustStrategy = AUTO_ADJUST_REALTIME_VIDEOCHAT_STRATEGY;
    

    pusher = [[TXLivePush alloc] initWithConfig:pushconfig];
    pusher.delegate = self;
    [pusher showVideoDebugLog:TRUE];

    [pusher setVideoQuality:VIDEO_QUALITY_REALTIME_VIDEOCHAT
              adjustBitrate:YES
           adjustResolution:YES];
    
    pushconfig.videoBitrateMin = 100;
    pushconfig.videoBitrateMax = 250;
    pushconfig.videoResolution = VIDEO_RESOLUTION_TYPE_240_320;
    
    [pusher setConfig:pushconfig];
    
    [pusher startPush:pushUrl];
    
    pusherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    
    pusherView.backgroundColor = UIColor.blackColor;
    
    pusherView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:pusherView];
    [pusher startPreview:pusherView];
    
    
    playerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
    playerView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:playerView];
    
    player = [[TXLivePlayer alloc] init];
    player.delegate = self;
    
    TXLivePlayConfig *playconfig = [[TXLivePlayConfig alloc] init];
    playconfig.enableAEC = TRUE;
    playconfig.bAutoAdjustCacheTime = true;
    playconfig.rtmpChannelType = RTMP_CHANNEL_TYPE_PRIVATE;
    playconfig.cacheTime = 0.3;
    playconfig.minAutoAdjustCacheTime = 0.1;
    playconfig.maxAutoAdjustCacheTime = 0.3;
    
    
    playUrl = @"rtmp://19251.liveplay.myqcloud.com/live/stream2?bizid=19251&txSecret=44a6b19bce12aea4e7ade7b0dfbdd834&txTime=5CC870FF";
    
    [player setConfig:playconfig];
    [player setupVideoWidget:CGRectMake(0, 0, 100, 100) containView:playerView insertIndex:0];
    [player setRenderMode:RENDER_MODE_FILL_EDGE];
    
    //[player startPlay:playUrl type:PLAY_TYPE_LIVE_RTMP_ACC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// delegate
-(void) onPushEvent:(int)EvtID withParam:(NSDictionary*)param
{
    
    // 推流成功
    if (EvtID == 1001) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
             [player startPlay:playUrl type:PLAY_TYPE_LIVE_RTMP_ACC];
        });
       
    }
}

-(void) onNetStatus:(NSDictionary*) param
{
     NSLog(@"onNetStatus  %@", param);
}


-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param
{
    //NSLog(@"onPlayEvent %d,  %@", EvtID, param);
}



@end
