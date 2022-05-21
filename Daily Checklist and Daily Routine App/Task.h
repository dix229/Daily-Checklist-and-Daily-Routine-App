#import <UIKit/UIKit.h>
#import "DB.h"
#import "SavedData.h"

@interface Task : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIDatePicker *datepick;
    UIDatePicker *timepick;
}

@property(strong,nonatomic) IBOutlet UIButton *back;
@property(strong,nonatomic) IBOutlet UIButton *bell;
@property(strong,nonatomic) IBOutlet UITextField *Tname;
@property(strong,nonatomic) IBOutlet UITextField *Tdate;
@property(strong,nonatomic) IBOutlet UITextField *Ttime;
@property(strong,nonatomic) IBOutlet UISegmentedControl *selection;
@property(strong,nonatomic) IBOutlet UIButton *Monday;
@property(strong,nonatomic) IBOutlet UIButton *Tuesday;
@property(strong,nonatomic) IBOutlet UIButton *Wednesday;
@property(strong,nonatomic) IBOutlet UIButton *Thursday;
@property(strong,nonatomic) IBOutlet UIButton *Friday;
@property(strong,nonatomic) IBOutlet UIButton *Saturday;

@property(strong,nonatomic) IBOutlet UIStackView *stack1;
@property(strong,nonatomic) IBOutlet UIStackView *stack2;
@property(strong,nonatomic) IBOutlet UIStackView *stack3;
@property(strong,nonatomic) IBOutlet UIStackView *stack4;

@property(strong,nonatomic) IBOutlet UIButton *Sunday;
@property(strong,nonatomic) IBOutlet UIButton *Remove;

-(IBAction)back_click:(id)sender;
-(IBAction)bell_click:(id)sender;
-(IBAction)segment_click:(id)sender;
-(IBAction)monday_click:(id)sender;
-(IBAction)tuesday_click:(id)sender;
-(IBAction)wednesday_click:(id)sender;
-(IBAction)thursday_click:(id)sender;
-(IBAction)friday_click:(id)sender;
-(IBAction)saturday_click:(id)sender;
-(IBAction)sunday_click:(id)sender;
-(IBAction)remove_click:(id)sender;
-(IBAction)submit_click:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selectionheight;
@property (strong, nonatomic) IBOutlet UIView *dateview;


@end

