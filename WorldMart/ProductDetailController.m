//
//  ProductDetailController.m
//  WorldMart
//
//  Created by Adit Hasan on 1/7/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import "ProductDetailController.h"
#import "AppDelegate.h"
@interface ProductDetailController ()

@end

@implementation ProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title=[self.productDetail valueForKey:@"productname"];
    [self.productPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://54.169.94.38:8080/mycompanyAPI%@",[self.productDetail valueForKey:@"photo"]]]];
    NSLog(@"URL %@",[NSString stringWithFormat:@"http://54.169.94.38:8080/mycompanyAPI%@",[self.productDetail valueForKey:@"photo"]]);
    self.Quantitys.text=[NSString stringWithFormat:@"%@",[self.productDetail valueForKey:@"quantity"]];
    self.discription.text=[self.productDetail valueForKey:@"description"];
    self.productName.text=[self.productDetail valueForKey:@"productname"];
    self.price.text=[NSString stringWithFormat:@"$ %@",[self.productDetail valueForKey:@"price"]];
    self.vendorName.text=[NSString stringWithFormat:@"By %@",[self.productDetail valueForKey:@"vendername"]];
    self.MainScrollView.contentSize=CGSizeMake([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height+250);
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

- (IBAction)AddToCart:(id)sender {
    
    [[[UserInfo instance] userCart] addObject:self.productDetail];
    
    UILabel *lbl = (UILabel*)[(UIView*)[self.navigationController.navigationBar viewWithTag:102] viewWithTag:101];
    lbl.text= [NSString stringWithFormat:@"%lu",(unsigned long)[[[UserInfo instance] userCart] count]];
    
    NSLog(@"%@",[[UserInfo instance] userCart]);
    
    
}
@end
