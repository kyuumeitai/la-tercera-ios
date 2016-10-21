//
//  VideoPlayerViewController.m
//  La Tercera
//
//  Created by Mario Alejandro on 19-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "AppDelegate.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController
@synthesize videoURL;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Aca estaa");
    
    NSString *fullURL = self.videoURL;
    
    NSString *embedHTML =[NSString stringWithFormat:@"%@?autoplay=1",fullURL];
    NSURL *url = [NSURL URLWithString:embedHTML];
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
-(BOOL)shouldAutorotate{
    return YES;
}
@end
