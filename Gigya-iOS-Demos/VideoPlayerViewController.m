//
//  VideoPlayerViewController.m
//  La Tercera
//
//  Created by Mario Alejandro on 19-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "AppDelegate.h"
#import "MediaPlayer/MediaPlayer.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController
@synthesize videoURL;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Aca estaa");
    

    
    NSString *fullURL = self.videoURL;
    
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_videoWebView loadRequest:requestObj];
    

   /*
    NSURL *nsurl=[NSURL URLWithString:@"www.google.cl"];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    _videoWebView.scalesPageToFit = YES;
    _videoWebView.mediaPlaybackRequiresUserAction = NO;
    _videoWebView.allowsInlineMediaPlayback = NO;
    
    [_videoWebView loadRequest:nsrequest];
    // Do any additional setup after loading the view.
    */
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [UIView setAnimationsEnabled:NO];
    
    // Stackoverflow #26357162 to force orientation
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIViewController attemptRotationToDeviceOrientation];
}

-(void) viewWillDisappear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)abckButton:(id)sender {
    [[self navigationController] popViewControllerAnimated:NO];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UIInterfaceOrientationPortrait | UIInterfaceOrientationPortrait);
}
-(BOOL)shouldAutorotate{
    return YES;
}
@end
