//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"

#import "AppDelegate.h"
#import "CustomCell.h"

@interface LeftMenuViewController()
@property(nonatomic,strong)NSMutableArray *menuItems;
@end
@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = YES;
	return [super initWithCoder:aDecoder];
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.separatorColor = [UIColor blackColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MenuTable.png"]];
	self.tableView.backgroundView = imageView;
	
	self.view.layer.borderWidth = .6;
	self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    if ([[vComp objectAtIndex:0] intValue] >= 7) {
        
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
        view.backgroundColor=[[AppDelegate shareDelegate] colorFromHexString:@"737373"];
        [self.view addSubview:view];
        
    }
 
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSDictionary *info=[[NSUserDefaults standardUserDefaults] objectForKey:@"userdata"];
//    if ([[info valueForKey:@"usertype"] isEqualToString:@"vendor"])
//    {
//    self.menuItems=[[NSMutableArray alloc] initWithObjects:@"My Product",@"Payment",@"MyProduct",@"My Account",@"About",@"FAQ",@"Contact Us", nil];
//    }else{
    self.menuItems = [[NSMutableArray alloc] initWithObjects:@"Home",@"Shop by Department",@"Your Order",@"Your Account",@"About",@"FAQ",@"Contact US", nil];
   // }
    [self.tableView reloadData];

}

#pragma mark - UITableView Delegate & Datasrouce -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}             // Default is 1 if not implemented

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section==0) {
//        return 7;
//    }else
//	return 2;
    
    return [self.menuItems count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)] ;
    [headerView setBackgroundColor:[[AppDelegate shareDelegate] colorFromHexString:@"2d2d2d"]];
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, headerView.frame.size.width,  headerView.frame.size.height)];
    [lblContent setFont:[UIFont boldSystemFontOfSize:12]];
    [lblContent setTextColor:[UIColor whiteColor]];
    
    switch (section) {
        case 0:
            lblContent.text= @"MENU";
            break;
        case 1:
            lblContent.text= @"Support";
            break;
       
    }
    
    
    [headerView addSubview:lblContent];
    return headerView;
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    // Background color
//    view.tintColor = [UIColor blackColor];
//    
//    // Text Color
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    [header.textLabel setTextColor:[UIColor whiteColor]];
//    [view setBackgroundColor:[UIColor blackColor]];
//    // Another way to set the background color
//    // Note: does not preserve gradient effect of original header
//    // header.contentView.backgroundColor = [UIColor blackColor];
//}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    cell.backgroundColor=[UIColor clearColor];
    cell.customTextLabel.text=[self.menuItems objectAtIndex:indexPath.row];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOpacity = 0.1;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowColor = [[AppDelegate shareDelegate] colorFromHexString:@"3b3b3b"].CGColor;
    cell.layer.shadowRadius = 0;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
															 bundle: nil];
	
	UIViewController *vc ;

	switch (indexPath.row)
	{
		case 0:
			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
			[[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
			break;
			
		case 1:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"Categories"];
			break;
        case 2:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"OrderViewController"];
			break;
		case 3:
            
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
            {
              vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"YourAccountController"];
            }else{
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"LoginController"];
            }
			break;
        
        case 4:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ViewController"];
			break;
            
        case 5:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ViewController"];
			break;
	
            
    /// self.menuItems=[[NSMutableArray alloc] initWithObjects:@"Categories",@"OrderViewController",@"My Account",@"About",@"FAQ",@"Contact Us", nil];
    // self.menuItems = [[NSMutableArray alloc] initWithObjects:@"Home",@"Shop by Department",@"Your Order",@"Your Account",@"About",@"FAQ",@"Contact US", nil];
        case 6:
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
            return;
			break;
     
	}

    
    
    
    
    
    
    
    
	
	[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
															 withSlideOutAnimation:self.slideOutAnimationEnabled
																	 andCompletion:^{
                                                                         
                                         [tableView deselectRowAtIndexPath:indexPath animated:YES];                                    
                                                                     
                                                                     }];
}

@end
