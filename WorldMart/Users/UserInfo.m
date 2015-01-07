//
//  GetCountryCode.m
//  Unicabi
//
//  Created by AITL on 11/24/13.
//
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize userAddress;
@synthesize userCompanyName;
@synthesize userEmail;
@synthesize userFirstName;
@synthesize userId;
@synthesize userLastName;
@synthesize userLicenseNo;
@synthesize userType;
@synthesize userCart;

- (id) initSingleton
{
    if ((self = [super init]))
    {
        userCart = [[NSMutableArray alloc]init];
        
    }
    
    return self;
}

+ (UserInfo *) instance
{
    // Persistent instance.
    static UserInfo *_default = nil;
    if (_default != nil)
    {
        return _default;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    // Allocates once with Grand Central Dispatch (GCD) routine.
    // It's thread safe.
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void)
                  {
                      _default = [[UserInfo alloc] initSingleton];
                  });
#else
    // Allocates once using the old approach, it's slower.
    // It's thread safe.
    @synchronized([UserInfo class])
    {
        // The synchronized instruction will make sure,
        // that only one thread will access this point at a time.
        if (_default == nil)
        {
            _default = [[MySingleton alloc] initSingleton];
        }
    }
#endif
    return _default;
}

//@synthesize userAddress;
//@synthesize userCompanyName;
//@synthesize userEmail;
//@synthesize userFirstName;
//@synthesize userId;
//@synthesize userLastName;
//@synthesize userLicenseNo;
//@synthesize userType;
//@synthesize userCart;

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:userFirstName forKey:@"firstName"];
    [encoder encodeObject:userLastName forKey:@"lastName"];
    [encoder encodeObject:userEmail forKey:@"userEmail"];
    [encoder encodeObject:userId forKey:@"userid"];
    [encoder encodeObject:userAddress forKey:@"userAddress"];
    [encoder encodeObject:userLicenseNo forKey:@"licenseNo"];
    [encoder encodeObject:userCompanyName forKey:@"companyName"];
    [encoder encodeObject:userType forKey:@"userType"];
    [encoder encodeObject:userCart forKey:@"userCart"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init]))
    {
        [decoder decodeObjectForKey:@"firstName"];
        [decoder decodeObjectForKey:@"lastName"];
        [decoder decodeObjectForKey:@"userEmail"];
        [decoder decodeObjectForKey:@"userid"];
        [decoder decodeObjectForKey:@"userAddress"];
        [decoder decodeObjectForKey:@"licenseNo"];
        [decoder decodeObjectForKey:@"companyName"];
        [decoder decodeObjectForKey:@"userType"];
        [decoder decodeObjectForKey:@"userCart"];
    }
    return self;
}


@end
