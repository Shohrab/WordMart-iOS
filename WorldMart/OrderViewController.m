//
//  OrderViewController.m
//  WorldMart
//
//  Created by Adit Hasan on 1/7/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import "OrderViewController.h"
#import "AppDelegate.h"
#import "UserInfo.h"
@interface OrderViewController ()
@property(nonatomic,strong)NSMutableArray *orderList;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderList=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)viewDidAppear:(BOOL)animated{
    
    [self LoadOrderListRequest];
    
}




- (NSMutableDictionary*)InputDataString {
    
    NSMutableDictionary *MutableDictionary = [[NSMutableDictionary alloc] init];
    
    [MutableDictionary setObject:@"orderbycustomer" forKey:@"tag"];
    [MutableDictionary setObject:[[UserInfo instance] userId] forKey:@"customer_id"];
    
    return MutableDictionary;
}


// Send current location
- (void) LoadOrderListRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSLog(@"Input %@",[self InputDataString]);
    
    NSString *requestingLocationUrl = [NSString stringWithFormat:@"orderlist"] ;
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:MainServices]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:requestingLocationUrl
                                                      parameters:[self InputDataString]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *temp = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] JSONValue];
        
        
        NSLog(@"Order Response-%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        if ([[temp valueForKey:@"success"] intValue]) {
            
             self.orderList = [temp valueForKey:@"data"];
            
        }else{
        
            [[AppDelegate shareDelegate] customAlert:@"Warning!" withMessage:@"You have't create any order."];
        }
        [self.OrderTable reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [operation start];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.orderList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    /*
     *   If the cell is nil it means no cell was available for reuse and that we should
     *   create a new one.
     */
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.textLabel.text=[[self.orderList objectAtIndex:indexPath.row] valueForKey:@"productname"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"$ %@,Quantity %@",[[self.orderList objectAtIndex:indexPath.row] valueForKey:@"price"],[[self.orderList objectAtIndex:indexPath.row] valueForKey:@"quantity"]];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOpacity = 0.1;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowColor = [[AppDelegate shareDelegate] colorFromHexString:@"3b3b3b"].CGColor;
    cell.layer.shadowRadius = 0;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ViewController *views = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [views setCategoryID:[[self.orderList objectAtIndex:indexPath.row] valueForKey:@"id"]];
    [self.navigationController pushViewController:views animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
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
