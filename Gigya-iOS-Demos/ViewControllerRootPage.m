//
//  ViewControllerRootPage.m
//  La Tercera
//
//  Created by diseno on 25-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ViewControllerRootPage.h"
#import "PageContentViewController.h"

@interface ViewControllerRootPage ()

@end

@implementation ViewControllerRootPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
      _pageImages = @[@"comoFunciona1", @"comoFunciona2", @"comoFunciona3", @"comoFunciona4",@"comoFunciona5", @"comoFunciona6", @"comoFunciona7", @"comoFunciona8", @"comoFunciona9", @"comoFunciona10", @"comoFunciona11"];
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
   // [self startWalkthrough];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{

    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {

           return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.pageIndex = index;
    if (index == [self.pageImages count]-1){
        //
        NSLog(@"Estoy aca lonyi");
        pageContentViewController.isFinalPage = true;
    }
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    
    index++;
    if (index == [self.pageImages count]) {
        
        return nil;
    }
    
    if(index ==1){
        ((PageContentViewController*) viewController).finishButton.hidden= false;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
   
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
