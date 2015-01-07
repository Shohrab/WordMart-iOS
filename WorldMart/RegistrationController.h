//
//  RegistrationController.h
//  WorldMart
//
//  Created by Adit Hasan on 1/6/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractActionSheetPicker.h"
#import "ActionSheetCustomPicker.h"
#import "ActionSheetCustomPickerDelegate.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetDistancePicker.h"
#import "ActionSheetLocalePicker.h"
#import "ActionSheetStringPicker.h"
#import "DistancePickerView.h"
#import "SWActionSheet.h"

#import "AddressFilterView.h"
@interface RegistrationController : UIViewController<UITextFieldDelegate,AddressFilterDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtfirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtlastName;
@property (weak, nonatomic) IBOutlet UITextField *txtemail;
@property (weak, nonatomic) IBOutlet UITextField *txtpassword;

@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtZip;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtCIty;

@property (weak, nonatomic) IBOutlet UITextField *txtUserType;


@property (weak, nonatomic) IBOutlet UIScrollView *MainScrollView;
@end
