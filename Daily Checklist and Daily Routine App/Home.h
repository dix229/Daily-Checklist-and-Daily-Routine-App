#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "DB.h"
#import "ListAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface Home : UIViewController<UITableViewDataSource>

@property(strong,nonatomic) IBOutlet UITableView *Table;

@property(strong,nonatomic) IBOutlet UILabel *monD;
@property(strong,nonatomic) IBOutlet UILabel *tueD;
@property(strong,nonatomic) IBOutlet UILabel *wedD;
@property(strong,nonatomic) IBOutlet UILabel *thuD;
@property(strong,nonatomic) IBOutlet UILabel *friD;
@property(strong,nonatomic) IBOutlet UILabel *satD;
@property(strong,nonatomic) IBOutlet UILabel *sunD;
@property (strong, nonatomic) IBOutlet UIImageView *nolistimg;

@property(strong,nonatomic) IBOutlet UIView *monV;
@property(strong,nonatomic) IBOutlet UIView *tueV;
@property(strong,nonatomic) IBOutlet UIView *wedV;
@property(strong,nonatomic) IBOutlet UIView *thuV;
@property(strong,nonatomic) IBOutlet UIView *friV;
@property(strong,nonatomic) IBOutlet UIView *satV;
@property(strong,nonatomic) IBOutlet UIView *sunV;

-(IBAction)mon_click:(id)sender;
-(IBAction)tue_click:(id)sender;
-(IBAction)wed_click:(id)sender;
-(IBAction)thu_click:(id)sender;
-(IBAction)fri_click:(id)sender;
-(IBAction)sat_click:(id)sender;
-(IBAction)sun_click:(id)sender;

-(IBAction)add_click:(id)sender;
-(IBAction)cal_click:(id)sender;

@end

NS_ASSUME_NONNULL_END
