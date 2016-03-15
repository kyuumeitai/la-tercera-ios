//
//  InfantilTableViewController.m
//  La Tercera
//
//  Created by diseno on 15-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "InfantilTableViewController.h"
#import  "CategoriasTableViewCell.h"
#import  "DestacadoTableViewCell.h"


@interface InfantilTableViewController ()

@end

@implementation InfantilTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"BanioTableCell";
    
    
  
        /*MyManager *singleton = [MyManager sharedManager];
        NSString *storyBoardName = singleton.storyBoardName;
        
        
        if ([storyBoardName isEqualToString:@"MainStoryboard-iPhone4"] )
            nib = [[NSBundle mainBundle] loadNibNamed:@"BaniosTableViewCell-iPhone4" owner:self options:nil];
        if ([storyBoardName isEqualToString:@"MainStoryboard-iPhone5"] )
            nib = [[NSBundle mainBundle] loadNibNamed:@"BaniosTableViewCell-iPhone5" owner:self options:nil];
        if ([storyBoardName isEqualToString:@"MainStoryboard-iPhone6"] )
            nib = [[NSBundle mainBundle] loadNibNamed:@"BaniosTableViewCell-iPhone6" owner:self options:nil];
        if ([storyBoardName isEqualToString:@"MainStoryboard-iPhone6Plus"] )
         */
        NSArray *nib;
        
        if (indexPath.row==0) {
            DestacadoTableViewCell *cell = (DestacadoTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil)
            {
            nib = [[NSBundle mainBundle] loadNibNamed:@"DestacadoTableViewCell" owner:self options:nil];
               cell = [nib objectAtIndex:0];
            }
            return cell;
        }else{
            CategoriasTableViewCell *cell = (CategoriasTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
            
            nib = [[NSBundle mainBundle] loadNibNamed:@"CategoriasTableViewCell" owner:self options:nil];
               cell = [nib objectAtIndex:0];
           }
            
     
            return cell;
       }
    
    
        //cell.contentView.layer.borderColor = [[UIColor grayColor] CGColor];
        //cell.contentView.layer.borderWidth = 0.5;
         /*
        cell.layer.masksToBounds = NO;
        cell.layer.borderColor = [UIColor grayColor].CGColor;
        cell.layer.borderWidth = 2.0f;
        cell.layer.contentsScale = [UIScreen mainScreen].scale;
       
        cell.layer.shadowOpacity = 0.75f;
        cell.layer.shadowRadius = 2.0f;
        cell.layer.shadowOffset = CGSizeZero;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
        cell.layer.shouldRasterize = YES;
         */

    
    /*
    BanioItem *banito = baniosItemsArray[indexPath.row];
    NSLog(@"Desc baño: %@",banito.descripcion);
    
    cell.labelDescripcion.text = banito.descripcion;
    cell.imagenBanio.image = banito.imagenBanio;
    cell.labelDistancia.text = banito.distanciaEnMetros;
    cell.labelLikes.text = [NSString stringWithFormat:@"%d",banito.likes];
    
    cell.imagenConConfort.image = [UIImage imageNamed:@"iconoFav"];
    NSLog(@"Entonces mi bañoID es: %@",banito.banioId);
    */


}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 250.0;
    }
    else {
        return 80.0;
    }   
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
