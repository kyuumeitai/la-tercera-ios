//
//  LaTerceraTV.m
//  La Tercera
//
//  Created by diseno on 07-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "LectiosViewController.h"
#import "SessionManager.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

static NSString * const LectiosBaseURLString = @"http://api.lectios.com/?a=url&idCode=QB6SFF89&url=";


@implementation LectiosViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [SVProgressHUD show];
    //[self loadPaper];
    //[SVProgressHUD setStatus:@"Obteniendo categorías disponibles"];
    // Do any additional setup after loading the view.
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
      self.audioPlayer = [[YMCAudioPlayer alloc] init];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    sesion.leftSlideMenu = revealViewController;
    [_menuButton addTarget:sesion.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];

    
    /*
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        // Perform async operation
        [self loadPlayer];
        dispatch_sync(dispatch_get_main_queue(), ^{
            // Update UI
            // Example:
            [SVProgressHUD show];
        });
    });
     
     */
        NSString *articleURL = @"http://especiales.latercera.com/test/lectios.html";
    [self getLectiosResponseForArticleURL:articleURL];
    
}

-(void) getLectiosResponseForArticleURL:(NSString*)articleURL{

    NSString *url= [NSString stringWithFormat:@"%@%@",LectiosBaseURLString,articleURL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *array = (NSDictionary*) responseObject[0];
        NSArray *dictio =[array objectForKey:@"articleData"];
        NSDictionary *dictioInner = (NSDictionary*) dictio[0];
        NSString *isReady = [dictioInner objectForKey:@"status"];
         NSString *audioURL = [dictioInner objectForKey:@"audioUrl"];
        
        if ([isReady isEqualToString:@"ready"]){
            
            NSLog(@"Esta iooo");
           [SVProgressHUD dismiss];
          
            [self setupAudioPlayerWithArticle:audioURL];
        }else{
            NSLog(@"Le falta");
              [SVProgressHUD show];
            [SVProgressHUD setStatus:@"Convirtiendo a mp3"];
    
               [self performSelector:@selector(goingBackWithURL:) withObject:articleURL afterDelay:2.0];

            
        }
        
        //NSArray *json = [NSJSONSerialization JSONObjectWithData:dictio options:0 error:&parseError];
        NSLog(@"Parsed JSON: %@", dictio);
        // do something with `json`
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
}

-(void)goingBackWithURL:(NSString*)url{
    
    [self getLectiosResponseForArticleURL:url];
    
}

-(void)loadPlayer{
    
   
    
    
}

/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
- (void)setupAudioPlayerWithArticle:(NSString*)stringArticle
{
    //insert URL

    
    
    NSURL *mp3URL = [NSURL URLWithString:stringArticle];
    //init the Player to get file properties to set the time labels
    [self.audioPlayer initPlayer:mp3URL];
    //init the current timedisplay and the labels. if a current time was stored
    //for this player then take it and update the time display
    self.timeElapsed.text = @"0:00";
 
}

/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */
- (IBAction)playAudioPressed:(id)playButton
{
    
    self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
    
    
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
    [self.timer invalidate];
    //play audio for the first time or if pause was pressed
    if (!self.isPaused) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_pause.png"]
                                   forState:UIControlStateNormal];
        
        //start a timer to update the time label display
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.audioPlayer playAudio];
        self.isPaused = TRUE;
        
    } else {
        //player is paused and Button is pressed again
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_play.png"]
                                   forState:UIControlStateNormal];
        
        [self.audioPlayer pauseAudio];
        self.isPaused = FALSE;
    }
}

/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
- (void)updateTime:(NSTimer *)timer {
  
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing) {
        self.currentTimeSlider.value = [self.audioPlayer getCurrentAudioTime];
    }
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self.audioPlayer timeFormat:[self.audioPlayer getCurrentAudioTime]]];
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration] - [self.audioPlayer getCurrentAudioTime]]];
    
    //When resetted/ended reset the playButton
    if (![self.audioPlayer isPlaying]) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_play.png"]
                                   forState:UIControlStateNormal];
        [self.audioPlayer pauseAudio];
        self.isPaused = FALSE;
    }
}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
 */
- (IBAction)setCurrentTime:(id)scrubber {
    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [self.audioPlayer setCurrentAudioTime:self.currentTimeSlider.value];
    self.scrubbing = FALSE;
}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */
- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = TRUE;
}

-(void) viewWillDisappear:(BOOL)animated{
    
   // [self.audioPlayer stop]
}


@end
