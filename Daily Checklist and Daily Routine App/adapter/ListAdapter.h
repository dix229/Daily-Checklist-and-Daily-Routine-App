#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "DB.h"
#import "SavedData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListAdapter : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *circle;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *datetime;
@property (strong, nonatomic) IBOutlet UIButton *bell;
@property (strong, nonatomic) IBOutlet UIButton *checkbox;

- (IBAction)bell_click:(id)sender;
- (IBAction)check_click:(id)sender;
- (IBAction)more_click:(id)sender;

@property(strong,nonatomic)IBOutlet UIViewController *vc;
@property(strong,nonatomic)IBOutlet UITableView *Table;
@property(strong,nonatomic)IBOutlet NSMutableArray *Tmlist;
@property(strong,nonatomic)IBOutlet NSString *Pos;
@property(strong,nonatomic)IBOutlet NSString *Seldate;

@end

NS_ASSUME_NONNULL_END
