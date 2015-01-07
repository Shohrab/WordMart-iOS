//
//  GetCountryCode.h
//  Unicabi
//
//  Created by AITL on 11/24/13.
//
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>


+ (UserInfo *) instance;

@property(nonatomic,strong)NSString *userFirstName;

@property(nonatomic,strong)NSString *userLastName;

@property(nonatomic,strong)NSString *userEmail;

@property(nonatomic,strong)NSString *userId;

@property(nonatomic,strong)NSString *userAddress;

@property(nonatomic,strong)NSString *userLicenseNo;

@property(nonatomic,strong)NSString *userCompanyName;

@property(nonatomic,strong)NSString *userType;

@property(nonatomic,strong)NSMutableArray *userCart;


@end
