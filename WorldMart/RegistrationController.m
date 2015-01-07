//
//  RegistrationController.m
//  WorldMart
//
//  Created by Adit Hasan on 1/6/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import "RegistrationController.h"
#import "AppDelegate.h"

@interface RegistrationController ()

@end

@implementation RegistrationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Registration";
    self.MainScrollView.contentSize=CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width+300);
    
    self.MainScrollView.scrollEnabled=YES;
    
    self.txtUserType.delegate=self;
    
    self.txtpassword.secureTextEntry=YES;
    self.txtemail.text=@"skadithasan@yahoo.com";
    self.txtfirstName.text=@"Md Adit";
    self.txtlastName.text=@"Hasan";
    self.txtpassword.text=@"762213";
    UIBarButtonItem *signUpbutton = [[UIBarButtonItem alloc]initWithTitle:@"SignUp" style:UIBarButtonItemStylePlain target:self action:@selector(signup)];
    self.navigationItem.rightBarButtonItem=signUpbutton;
    
    for (UIView *subview in self.MainScrollView.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            [(UITextField*)subview setDelegate:self];
        }
    }
}

-(void)signup{

    BOOL success = false;
    for (UIView *subview in self.MainScrollView.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *txtField = (UITextField*)subview;
            if ([txtField.text length]!=0) {
                success=true;
            }else{
                success=false;
                [[AppDelegate shareDelegate] customAlert:@"Warning!" withMessage:@"Please fill up all the information currectly."];
                break;
            }
            
        }
    }

    [self RegistrationactionRequest];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (textField==self.txtUserType) {
        [self selectUserType:textField];
    }else if (textField==self.txtAddress){
    
        AddressFilterView *addressfilter=[[AddressFilterView alloc]initWithNibName:@"AddressFilterView" bundle:nil];
        addressfilter.delegate=self;
        addressfilter.TopbarTitle=NSLocalizedString(@"ENTER PICKUP", @"ENTER PICKUP");
        UINavigationController *navcontroller=[[UINavigationController alloc]initWithRootViewController:addressfilter];
        navcontroller.navigationBar.translucent=YES;
        [self presentViewController:navcontroller animated:YES completion:nil];
        return NO;
        
    }else if (textField==self.txtUserType){
    
    
    
    }
    return YES;
}

-(void)SelectedAddressFromList:(NSDictionary *)addressinfo{
    [self.txtAddress setText:[addressinfo valueForKey:@"address"]];
    [self.txtZip setText:[addressinfo valueForKey:@"postcode"]];
    [self.txtCountry setText:[addressinfo valueForKey:@"country"]];
    [self.txtCIty setText:[addressinfo valueForKey:@"city"]];
    [self.txtState setText:[addressinfo valueForKey:@"state"]];
    NSLog(@"Response -%@",addressinfo);
    
    //[self reverseGeocodeCurrentLocation:location];
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    for (UIView *subview in self.MainScrollView.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            [(UITextField*)subview resignFirstResponder];
        }
    }

    [textField resignFirstResponder];
    return YES;
}


- (IBAction)selectUserType:(id)sender{
    NSArray *currencyArray=[[NSArray alloc] initWithObjects:@"user",@"vendor", nil];
    
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        self.txtUserType.text=[currencyArray objectAtIndex:selectedIndex];
        
        
        [self.txtUserType resignFirstResponder];
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        
        [self.txtUserType resignFirstResponder];
    };
    
    [ActionSheetStringPicker showPickerWithTitle:@"User Type" rows:currencyArray initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}



- (NSMutableDictionary*)InputDataString {
    
    NSMutableDictionary *MutableDictionary = [[NSMutableDictionary alloc] init];
    
    [MutableDictionary setObject:self.txtfirstName.text forKey:@"firstname"];
    
    [MutableDictionary setObject:self.txtlastName.text forKey:@"lastname"];
    
    [MutableDictionary setObject:self.txtemail.text forKey:@"email"];
    
    [MutableDictionary setObject:self.txtpassword.text forKey:@"password"];
    
    [MutableDictionary setObject:self.txtAddress.text forKey:@"addressline"];
    
    [MutableDictionary setObject:self.txtCIty.text forKey:@"city"];
    
    [MutableDictionary setObject:self.txtState.text forKey:@"state"];
    
    [MutableDictionary setObject:self.txtZip.text forKey:@"zip"];
    
    [MutableDictionary setObject:self.txtCountry.text forKey:@"country"];
    
    [MutableDictionary setObject:self.txtUserType.text forKey:@"usertype"];
    
    return MutableDictionary;
}


// Send current location
- (void) RegistrationactionRequest {
    
    NSLog(@"Registration Input - %@",[self InputDataString]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *requestingLocationUrl = [NSString stringWithFormat:@"customer_add"] ;
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:MainServices]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:requestingLocationUrl
                                                      parameters:[self InputDataString]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *temp = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] JSONValue];
        NSLog(@" Response -%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        NSLog(@"JSON Response -%@",temp);
        
        
        
        if ([[temp valueForKey:@"success"] intValue]) {
            
             NSDictionary *userInfo = [temp valueForKey:@"data"];
            
            [[UserInfo instance] setUserEmail:[userInfo valueForKey:@"email"]];
            [[UserInfo instance] setUserId:[userInfo valueForKey:@"id"]];
            [[UserInfo instance] setUserAddress:[userInfo valueForKey:@"addressline"]];
            [[UserInfo instance] setUserType:[userInfo valueForKey:@"usertype"]];
            
            
            
            if ([[[UserInfo instance] userType] isEqualToString:@"vendor"]) {
                
                [[UserInfo instance] setUserLicenseNo:[userInfo valueForKey:@"license_number"]];
                [[UserInfo instance] setUserCompanyName:[userInfo valueForKey:@"company_name"]];
            }
            
            
        }
        
        
        
        
        
            [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    [operation start];
    
    
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
