//
//  MenuViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "SessionManager.h"
#import "Tools.h"


@implementation SWUITableViewCell

@end

@implementation MenuViewController{
    
    __weak IBOutlet UIButton *barButonItem;
    NSArray *menuItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    SessionManager *sesion = [SessionManager session];
    NSString *stbName = sesion.storyBoardName;
    
    
    if([stbName isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [stbName isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
    menuItems = @[@"categoria1", @"categoria2", @"categoria15",@"categoria3", @"categoria4", @"categoria5",@"categoria6", @"categoria7", @"categoria8",@"categoria9", @"categoria10",@"categoria13"];
    }else{
    menuItems = @[@"categoria11",@"categoria1", @"categoria2", @"categoria15",@"categoria3", @"categoria4", @"categoria5",@"categoria6", @"categoria7", @"categoria8",@"categoria9", @"categoria10",  @"categoria12", @"categoria13"];
    
    }
    //self.automaticallyAdjustsScrollViewInsets = NO;

  [self viewWillLayoutSubviews];
    //[self.tableView reloadData];
 

    
}

-(void)viewWillAppear:(BOOL)animated{
    //self.automaticallyAdjustsScrollViewInsets = false;
    //self.tableView.autoresizingMask = NO;
 //[self.navigationController setNavigationBarHidden:YES animated:animated];

}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    self.tableView.autoresizingMask = NO;
    //[self.tableView reloadData];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath2
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
   }


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    return cell;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 13)
        return 100.0;
    if (indexPath.row == 11)
        return 12.0;
    return 44.0;
}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.tableView setContentInset:UIEdgeInsetsMake(25,0,0,0)];

}

#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}
- (IBAction)ticketsFromMenuPressed:(id)sender {
    
    [Tools openSafariWithURL:@"http://tienda.clublatercera.com/tickets" ];

}

@end
