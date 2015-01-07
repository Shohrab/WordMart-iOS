//
//  LoginController.m
//  WorldMart
//
//  Created by Adit Hasan on 1/6/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import "LoginController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "SBJSON.h"


#import "UserInfo.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtEmail.text=@"uurtsaikha@yahoo.com";
    self.txtPassword.text=@"uuree";
    self.txtEmail.delegate=self;
    self.txtPassword.delegate=self;
    self.txtPassword.secureTextEntry=YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

  
    if (1) {
        if ([self.txtEmail.text length]!=0&&[self.txtPassword.text length]!=0) {
            [self LoginActionRequest];
        }else{
        
            [[AppDelegate shareDelegate] customAlert:@"Warning!" withMessage:@"Your have entered wrong password or email"];
        }
        
    }
    return true;
}

- (NSMutableDictionary*)InputDataString {
    
    NSMutableDictionary *MutableDictionary = [[NSMutableDictionary alloc] init];
    
    [MutableDictionary setObject:self.txtEmail.text forKey:@"email"];
    
    [MutableDictionary setObject:self.txtPassword.text forKey:@"password"];
    
    return MutableDictionary;
}


// Send current location
- (void) LoginActionRequest {
    
    NSLog(@"Input %@",[self InputDataString]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *requestingLocationUrl = [NSString stringWithFormat:@"login"] ;
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:MainServices]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:requestingLocationUrl
                                                      parameters:[self InputDataString]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *temp = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] JSONValue];
        NSLog(@"Login Response-%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        
        UserInfo *userinfoObj=[UserInfo instance];
        
        if ([[temp valueForKey:@"success"] intValue]) {
            
             NSDictionary *userInfo = [temp valueForKey:@"data"];
            [userinfoObj setUserEmail:[userInfo valueForKey:@"email"]];
            [userinfoObj setUserId:[userInfo valueForKey:@"id"]];
            [userinfoObj setUserAddress:[userInfo valueForKey:@"addressline"]];
            [userinfoObj setUserType:[userInfo valueForKey:@"usertype"]];
        
         
            
            if ([[userinfoObj userType] isEqualToString:@"vendor"]) {
              
                [userinfoObj setUserLicenseNo:[userInfo valueForKey:@"license_number"]];
                [userinfoObj setUserCompanyName:[userInfo valueForKey:@"company_name"]];
            }
            
            
        }
        
       // [NSKeyedArchiver archiveRootObject:userinfoObj toFile:@"userdata"];
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:userinfoObj];
      [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:@"userdata"];
        
    
        
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
