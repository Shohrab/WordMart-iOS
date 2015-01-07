//
//  Categories.m
//  WorldMart
//
//  Created by Adit Hasan on 1/7/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import "Categories.h"
#import "AppDelegate.h"
@interface Categories ()
@property(nonatomic,strong)NSMutableArray *categoryList;

@end

@implementation Categories

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Departments";
    self.categoryList=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)viewDidAppear:(BOOL)animated{
    
    [self LoadProductListRequest];
    
}




- (NSMutableDictionary*)InputDataString {
    
    NSMutableDictionary *MutableDictionary = [[NSMutableDictionary alloc] init];
    
    [MutableDictionary setObject:@"categories" forKey:@"tag"];
    
    return MutableDictionary;
}


// Send current location
- (void) LoadProductListRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSLog(@"Input %@",[self InputDataString]);
    
    NSString *requestingLocationUrl = [NSString stringWithFormat:@"categorylist"] ;
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:MainServices]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:requestingLocationUrl
                                                      parameters:[self InputDataString]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    NSDictionary *temp = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] JSONValue];
        
        
        
        
    if ([[temp valueForKey:@"success"] intValue]) {
            
    self.categoryList = [temp valueForKey:@"data"];
            
            NSLog(@"Category Response-%@",temp);
            
        }
        [self.catTable reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [operation start];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.categoryList count];
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
    cell.textLabel.text=[[self.categoryList objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOpacity = 0.1;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowColor = [[AppDelegate shareDelegate] colorFromHexString:@"3b3b3b"].CGColor;
    cell.layer.shadowRadius = 0;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ViewController *views = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [views setCategoryID:[[self.categoryList objectAtIndex:indexPath.row] valueForKey:@"id"]];
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
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
