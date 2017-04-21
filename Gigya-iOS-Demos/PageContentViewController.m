//
//  PageContentViewController.m
//  La Tercera
//
//  Created by diseno on 25-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "PageContentViewController.h"
#import "SessionManager.h"
#import "Tools.h"
#import "UserProfile.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _finishButton.hidden = true;
    _finishButton.alpha = 0.0;
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    
    if (_isFinalPage){
        NSLog(@"Es la página final");
        self.finishButton.hidden = false;
        _finishButton.alpha = 1.0; 
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
