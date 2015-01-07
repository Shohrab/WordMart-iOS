//
//  ViewController.m
//  WorldMart
//
//  Created by Adit Hasan on 1/6/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ProductCell.h"

#define PhotoRoot @"http://10.10.34.229:8080/mycompanyAPI"
@interface ViewController ()
{
    UIView *bagView;
}
@property(nonatomic,strong)NSMutableArray *productList;

@end

@implementation ViewController
{
    AppDelegate *appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"WorldMart";
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.translucent=NO;
    self.productList=[[NSMutableArray alloc] init];
    [self createBagView];
    [self.navigationController.navigationBar addSubview:bagView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    UILabel *bagCount = (UILabel*)[bagView viewWithTag:101];
    bagCount.text =[NSString stringWithFormat:@"%lu",(unsigned long)[[[UserInfo instance] userCart] count]];
}

-(void)createBagView
{
    bagView = [[UIView alloc]initWithFrame:CGRectMake(280, 12, 46, 34)];
    bagView.tag=102;
    bagView.backgroundColor = [UIColor clearColor];
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    img.image = [UIImage imageNamed:@"cartBtn.png"];
    [bagView addSubview:img];
    UILabel *bagCount = [[UILabel alloc]initWithFrame:CGRectMake(9, -4, 18, 18)];
    bagCount.font = [UIFont systemFontOfSize:14];
    bagCount.backgroundColor = [UIColor clearColor];
    bagCount.textColor = [UIColor grayColor];
    bagCount.textAlignment = NSTextAlignmentCenter;
    bagCount.tag = 101;
    bagCount.text = @"0";
    [bagView addSubview:bagCount];
}

-(void)viewDidAppear:(BOOL)animated{

    [self LoadProductListRequest];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSMutableDictionary*)InputDataString {
    
    NSMutableDictionary *MutableDictionary = [[NSMutableDictionary alloc] init];
    if (self.categoryID!=nil) {
    [MutableDictionary setObject:@"products" forKey:@"tag"];
    [MutableDictionary setObject:self.categoryID forKey:@"category_id"];
    }else
    [MutableDictionary setObject:@"allproducts" forKey:@"tag"];
    
    return MutableDictionary;
}


// Send current location
- (void) LoadProductListRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSLog(@"Input %@",[self InputDataString]);
    NSString *requestingLocationUrl=nil;
    
    if(self.categoryID!=nil)
    requestingLocationUrl = [NSString stringWithFormat:@"productsbycat"];
    else
    requestingLocationUrl = [NSString stringWithFormat:@"allproduct"] ;
    
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
            
            self.productList = [temp valueForKey:@"data"];

            
      
              NSLog(@"Product Response-%@",temp);
            
        }
        [self.listTableVIew reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
            [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [operation start];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.productList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"product";
    ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //cell.backgroundColor=[[AppDelegate shareDelegate] colorFromHexString:@"f4f4f4"];
    
    cell.titleLabel.text=[[self.productList objectAtIndex:indexPath.row] valueForKey:@"productname"];
    cell.txtPrice.text=[NSString stringWithFormat:@"$ %@",[[self.productList objectAtIndex:indexPath.row] valueForKey:@"price"]];
    NSLog(@"%@",[[self.productList objectAtIndex:indexPath.row] valueForKey:@"photo"]);
   // [cell.photoVIew setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoRoot,[[self.productList objectAtIndex:indexPath.row] valueForKey:@"photo"]]]];
    
    //UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(3, 10, 85, 125)];
    [cell.photoVIew setContentMode:UIViewContentModeScaleAspectFit];
    
    [cell.photoVIew setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://54.169.94.38:8080/mycompanyAPI%@",[[self.productList objectAtIndex:indexPath.row] valueForKey:@"photo"]]] placeholderImage:[UIImage imageNamed:@""]];
    
    
    cell.starrateView.backgroundColor=[[AppDelegate shareDelegate] colorFromHexString:@"f4f4f4"];
    [cell.starrateView setRate:4.5];
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOpacity = 0.1;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowColor = [[AppDelegate shareDelegate] colorFromHexString:@"3b3b3b"].CGColor;
    cell.layer.shadowRadius = 0;
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailController"];
    [view setProductDetail:[self.productList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:view animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    if (self.categoryID!=nil) {
     return NO;
    }else    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}

@end
