//
//  AppDelegate.h
//  WorldMart
//
//  Created by Adit Hasan on 1/6/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "JSON.h"
#import "SBJSON.h"
#import "UserInfo.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "ProductDetailController.h"
#import "ViewController.h"
#import "LoginController.h"
#import "OrderViewController.h"
#define MainServices @"http://54.169.94.38:8080/mycompanyAPI/service/"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,retain) UILabel *bagCount;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


+ (AppDelegate*)shareDelegate;
- (void)customAlert:(NSString*)title1 withMessage:(NSString*)message;
- (UIColor *) colorFromHexString:(NSString *)hexString;
@end

