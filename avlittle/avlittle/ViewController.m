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
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // random a pushUrl
    
    pushUrl = [NSString stringWithFormat:@"rtmp://101.201.141.179/live/%d", random()];
    
    NSLog(pushUrl);
    
    TXLivePushConfig *pushconfig = [[TXLivePushConfig alloc] init];
    pushconfig.enableAEC = TRUE;
    pushconfig.videoEncodeGop = 1;
    pushconfig.touchFocus = FALSE;
    pushconfig.videoFPS = 15;
    pushconfig.rtmpChannelType = RTMP_CHANNEL_TYPE_PRIVATE;

    pusher = [[TXLivePush alloc] initWithConfig:pushconfig];
    pusher.delegate = self;
    
    [pusher setVideoQuality:VIDEO_QUALITY_REALTIME_VIDEOCHAT
              adjustBitrate:YES
           adjustResolution:YES];
    
    [pusher startPush:pushUrl];
    
    pusherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    
    pusherView.backgroundColor = UIColor.blackColor;
    
    pusherView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:pusherView];
    [pusher startPreview:pusherView];
    
    
    playerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
    
    [self.view addSubview:playerView];
    
    player = [[TXLivePlayer alloc] init];
    player.delegate = self;
    
    TXLivePlayConfig *playconfig = [[TXLivePlayConfig alloc] init];
    playconfig.enableAEC = TRUE;
    playconfig.rtmpChannelType = RTMP_CHANNEL_TYPE_PRIVATE;
    playconfig.cacheTime = 0.3;
    playconfig.minAutoAdjustCacheTime = 0.1;
    playconfig.maxAutoAdjustCacheTime = 0.4;
    
    [player setConfig:playconfig];
    [player setupVideoWidget:CGRectMake(0, 0, 100, 100) containView:playerView insertIndex:0];
    [player setRenderMode:RENDER_MODE_FILL_EDGE];
    [player startPlay:pushUrl type:PLAY_TYPE_LIVE_RTMP_ACC];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// delegate
-(void) onPushEvent:(int)EvtID withParam:(NSDictionary*)param
{
    
    NSLog(@"onPushEvent %d,  %@", EvtID,  param);
}

-(void) onNetStatus:(NSDictionary*) param
{
    NSLog(@"onNetStatus: %@", param);
}


-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param
{
    NSLog(@"onPlayEvent %d,  %@", EvtID, param);
}



@end
