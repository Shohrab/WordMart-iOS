//
//  AddressFilterView.h
//  Unicabi
//
//  Created by Aitl on 3/23/14.
//
//

#import <UIKit/UIKit.h>

#import "AutoCompleteSearchViewController.h"

@class AddressFilterDelegate;

@protocol AddressFilterDelegate <NSObject>

-(void)SelectedAddressFromList:(NSDictionary*)addressinfo;


@end
@interface AddressFilterView : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,autocompleteDelegate>
{

    __weak IBOutlet UITextField *SearchTextField;
    __weak IBOutlet UITableView *AddressTableView;
    
    AutoCompleteSearchViewController *autocompleteObj;
    //FourSqureView *fourview;
    
}
@property(nonatomic,strong)NSString *TopbarTitle;
@property(nonatomic,strong)NSString *TextFieldPlaceHolder;
@property(nonatomic,strong)NSString *viewname;

@property(nonatomic,strong)NSMutableArray *NearestContentArray;
@property(nonatomic,strong)id<AddressFilterDelegate>delegate;

@end
