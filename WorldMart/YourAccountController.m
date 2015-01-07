//
//  YourAccountController.m
//  WorldMart
//
//  Created by Adit Hasan on 1/7/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import "YourAccountController.h"
#import "AppDelegate.h"
@interface YourAccountController ()

@end

@implementation YourAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Profile";
    //UILabel *lbl = (UILabel*)[(UIView*)[self.navigationController.navigationBar viewWithTag:102] viewWithTag:101];
    UIView *rightcartView = (UIView*)[self.navigationController.navigationBar viewWithTag:102];
    rightcartView.hidden=YES;
    
    UIBarButtonItem *signOutbutton = [[UIBarButtonItem alloc]initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(SignoutAction)];
    self.navigationItem.rightBarButtonItem=signOutbutton;
    

    self.txtFirstName.delegate=self;
    self.txtLastName.delegate=self;
    self.txtEmailAddress.delegate=self;
    self.txtAddress.delegate=self;
    self.txtState.delegate=self;
    self.txtZip.delegate=self;
    self.txtUserType.delegate=self;
    self.txtLicense.delegate=self;
    self.txtCompany.delegate=self;

    
    
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userdata"];
    NSLog(@"Userinfo - %@",userInfo);
    
    self.txtFirstName.text=[userInfo valueForKey:@"firstname"];
    self.txtLastName.text=[userInfo valueForKey:@"lastname"];
    self.txtEmailAddress.text=[userInfo valueForKey:@"email"];
    self.txtAddress.text=[userInfo valueForKey:@"addressline"];
    self.txtState.text=[userInfo valueForKey:@"state"];
    self.txtZip.text=[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"zip"]];
    self.txtUserType.text=[userInfo valueForKey:@"usertype"];
    if([[userInfo valueForKey:@"usertype"] isEqualToString:@"vendor"]) {
            self.txtLicense.text=[userInfo valueForKey:@"company_name"];
            self.txtCompany.text=[userInfo valueForKey:@"license_number"];
        }
 
}
-(void)SignoutAction{
    [[AppDelegate shareDelegate] resetDefaults];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //[textField resignFirstResponder];
    return NO;
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


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}

@end
