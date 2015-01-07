//
//  AutoCompleteSearchViewController.h
//  Unicabi
//
//  Created by AITL on 12/10/13.
//
//

#import <UIKit/UIKit.h>
@class autocompleteDelegate;
@protocol autocompleteDelegate <NSObject>

-(void)returnAddressListFromGoogle:(NSArray*)addresslistArray;
-(void)returnSelectedAddressLocFromGoogle:(NSDictionary*)addressInfo;

@end

@interface AutoCompleteSearchViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{

    IBOutlet UITextField *searchTextField;

    IBOutlet UITableView *AutoCompleteSearchTable;
}
@property(nonatomic,strong)id<autocompleteDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *NearestContentArray;

- (IBAction)DoneAction:(id)sender;
-(void)autocompleteSearch:(NSString*)searchText;
-(void)AddressInfoDetail:(NSString*)referenceCode;
-(BOOL)checkServiceAvailability:(NSString*)selectedPostCode;


@end
