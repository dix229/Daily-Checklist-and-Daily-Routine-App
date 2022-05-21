#import "TaskHistory.h"
#import "TaskModel.h"
#import "DB.h"
#import "ListAdapter.h"

@interface TaskHistory ()

@end

@implementation TaskHistory

NSMutableArray *Tmlist;
NSString *date,*day;
NSDate *today,*selday;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetInputType];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self LoadData];
}

-(void)SetInputType
{
    datepick=[[UIDatePicker alloc] init];
    datepick.datePickerMode=UIDatePickerModeDate;
    [self.datetext setInputView:datepick];
    
    UIToolbar *toolbar1=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolbar1 setTintColor:[UIColor blackColor]];
    UIBarButtonItem *canbtn1=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel_keyboard)];
    UIBarButtonItem *canbtn2=[[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(choose_date)];
    UIBarButtonItem *space1=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar1 setItems:[NSArray arrayWithObjects:space1,canbtn2,canbtn1, nil]];
    [self.datetext setInputAccessoryView:toolbar1];
    today=[[NSDate alloc] init];
    [datepick setDate:today];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    date=[formatter stringFromDate:today];
    self.datetext.text=[NSString stringWithFormat:@"%@",date];
    
    [formatter setDateFormat:@"EEEE"];
    day=[formatter stringFromDate:today];
}

-(void)cancel_keyboard
{
    [self.datetext resignFirstResponder];
}

-(void)choose_date
{
    selday=datepick.date;
    [self cancel_keyboard];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    date=[formatter stringFromDate:datepick.date];
    self.datetext.text=[NSString stringWithFormat:@"%@",date];
    
    [formatter setDateFormat:@"EEEE"];
    day=[formatter stringFromDate:datepick.date];
    [self LoadData];
}

-(IBAction)back_click:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)LoadData
{
    
    NSLog(@"date-%@",date);
    NSLog(@"day-%@",day);
    
    self.Table.dataSource=nil;
    [self.Table reloadData];
    
    DB *db=[[DB alloc] init];

    Tmlist=[db getalldata:date day:day];
    if(Tmlist!=NULL && Tmlist.count>0)
    {
        self.nolistimg.hidden=true;
        self.Table.dataSource=self;
        [self.Table reloadData];
    }
    else
    {
        self.nolistimg.hidden=false;
        NSLog(@"No");
    }
}

//Table functions
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Tmlist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier=@"cellidentifier";
    ListAdapter *cell=[tableView dequeueReusableCellWithIdentifier:cellidentifier forIndexPath:indexPath];
    
    long row=[indexPath row];
    
    TaskModel *tm=[Tmlist objectAtIndex:row];
    
    cell.vc=self;
    cell.Table=self.Table;
    cell.Tmlist=Tmlist;
    cell.Pos=[NSString stringWithFormat:@"%ld",row];
    cell.Seldate=date;
    cell.title.text=[tm getName];
    cell.datetime.text=[NSString stringWithFormat:@"%@ ( %@ )",[tm getTime],[tm getDate]];
    
    if([tm.getNotification isEqualToString:@"Yes"])
    {
        [cell.bell setImage:[UIImage imageNamed:@"bellring"] forState:UIControlStateNormal];
    }
    else{
        [cell.bell setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
    }
    
    if([tm.getStatus isEqualToString:@"Yes"])
    {
        [cell.checkbox setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    else{
        [cell.checkbox setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    
    if([tm.getStatus isEqualToString:@"Yes"])
    {
        [cell.circle setImage:[UIImage imageNamed:@"Gcircle"]];
    }
    else
    {
        NSDateFormatter *sdf=[[NSDateFormatter alloc] init];
        [sdf setDateFormat:@"yyyy/MM/dd"];
        
        NSArray *words = [tm.getTime componentsSeparatedByString:@":"];
        
        NSDate *mydate = [NSDate date];
        
        if(![[sdf stringFromDate:mydate] isEqualToString:date])
        {
            NSComparisonResult result1 = [today compare:selday];
            if(result1==NSOrderedAscending)
            {
                [cell.circle setImage:[UIImage imageNamed:@"Bcircle"]];
            }
            else if(result1==NSOrderedDescending)
            {
                [cell.circle setImage:[UIImage imageNamed:@"Rcircle"]];
            }
        }
        else
        {
            [sdf setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSCalendar* cal = [NSCalendar currentCalendar];
            NSDateComponents* comp = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:mydate];
            int year=[comp year];
            int month=[comp month];
            int day=[comp day];
            
            //        NSLog(@"%@",[sdf stringFromDate:mydate]);
            
            [comp setHour:[words[0] intValue]];
            [comp setMinute:[words[1] intValue]];
            NSDate *resultDate = [cal dateFromComponents:comp];
            //        NSLog(@"%@",[sdf stringFromDate:resultDate]);
            
            NSComparisonResult result;
            result = [mydate compare:resultDate];
            
            if(result==NSOrderedAscending)
            {
                [cell.circle setImage:[UIImage imageNamed:@"Bcircle"]];
            }
            else if(result==NSOrderedDescending)
            {
                [cell.circle setImage:[UIImage imageNamed:@"Rcircle"]];
            }
            else
            {
                [cell.circle setImage:[UIImage imageNamed:@"Bcircle"]];
            }
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row=[indexPath row];
    [self.Table reloadData];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


@end
