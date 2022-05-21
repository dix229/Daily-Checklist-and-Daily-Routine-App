#import "Task.h"

@interface Task ()

@end

@implementation Task

bool isMon,isTues,isWed,isThur,isFri,isSat,isSun,isnoti;
bool isAdd;
NSString * Fdate;
TaskModel *taskmodel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiaload];
}

-(void)initiaload
{
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.selection setTitleTextAttributes:attributes forState:UIControlStateNormal];
    isMon=isTues=isWed=isThur=isFri=isSat=isSun=isnoti=false;
    [self SetInputType];
    
    SavedData *sd=[[SavedData alloc] init];
    taskmodel=[sd getTask];
    if(taskmodel!=nil)
    {
        isAdd=false;
        _Remove.hidden=false;
        [self loadDefault];
    }
    else
    {
        isAdd=true;
        _Remove.hidden=true;
    }
    
}

- (IBAction)segment_click:(id)sender {
    
    if(self.selection.selectedSegmentIndex==0)
    {
        [self weekselected];
    }
    else
    {
        [self dateselected];
    }
}

-(void)weekselected
{
    self.selectionheight.constant=190;
    [self.dateview setNeedsUpdateConstraints];
    _Tdate.hidden=true;
    _stack1.hidden=false;
    _stack2.hidden=false;
    _stack3.hidden=false;
    _stack4.hidden=false;
}

-(void)dateselected
{
    self.selectionheight.constant=110;
    [self.dateview setNeedsUpdateConstraints];
    _Tdate.hidden=false;
    _stack1.hidden=true;
    _stack2.hidden=true;
    _stack3.hidden=true;
    _stack4.hidden=true;
}

-(IBAction)monday_click:(id)sender
{
    if(isMon)
        [self.Monday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    else
        [self.Monday setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    isMon=!isMon;
}

-(IBAction)tuesday_click:(id)sender
{
    if(isTues)
        [self.Tuesday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    else
        [self.Tuesday setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    isTues=!isTues;
}

-(IBAction)wednesday_click:(id)sender
{
    if(isWed)
        [self.Wednesday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    else
        [self.Wednesday setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    isWed=!isWed;
}


-(IBAction)thursday_click:(id)sender
{
    if(isThur)
        [self.Thursday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    else
        [self.Thursday setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    isThur=!isThur;
}


-(IBAction)friday_click:(id)sender
{
    if(isFri)
        [self.Friday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    else
        [self.Friday setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    isFri=!isFri;
}


-(IBAction)saturday_click:(id)sender
{
    if(isSat)
        [self.Saturday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    else
        [self.Saturday setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    isSat=!isSat;
}


-(IBAction)sunday_click:(id)sender
{
    if(isSun)
        [self.Sunday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    else
        [self.Sunday setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    isSun=!isSun;
}


-(IBAction)bell_click:(id)sender
{
    if(isnoti)
        [self.bell setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
    else
        [self.bell setImage:[UIImage imageNamed:@"bellring"] forState:UIControlStateNormal];
    
    isnoti=!isnoti;
}

-(void)SetInputType
{
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(cancel_keyboard)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    self.Tname.inputAccessoryView = keyboardToolbar;
    
    timepick=[[UIDatePicker alloc] init];
    timepick.datePickerMode=UIDatePickerModeTime;
    [self.Ttime setInputView:timepick];

    UIToolbar *toolbar2=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolbar2 setTintColor:[UIColor blackColor]];
    UIBarButtonItem *canbtn3=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel_keyboard)];
    UIBarButtonItem *nextbtn=[[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(choose_time)];
    UIBarButtonItem *space2=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    [toolbar2 setItems:[NSArray arrayWithObjects:space2,nextbtn,canbtn3, nil]];
    [self.Ttime setInputAccessoryView:toolbar2];
    
    datepick=[[UIDatePicker alloc] init];
    datepick.datePickerMode=UIDatePickerModeDate;
    [self.Tdate setInputView:datepick];
    
    UIToolbar *toolbar1=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolbar1 setTintColor:[UIColor blackColor]];
    UIBarButtonItem *canbtn1=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel_keyboard)];
    UIBarButtonItem *canbtn2=[[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(choose_date)];
    UIBarButtonItem *space1=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar1 setItems:[NSArray arrayWithObjects:space1,canbtn2,canbtn1, nil]];
    [self.Tdate setInputAccessoryView:toolbar1];
    NSDate *today=[[NSDate alloc] init];
    [datepick setMinimumDate:today];
}

-(IBAction)cancel_keyboard
{
    [self.Tdate resignFirstResponder];
    [self.Tname resignFirstResponder];
    [self.Ttime resignFirstResponder];
}

-(void)choose_time
{
    [self cancel_keyboard];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    self.Ttime.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:timepick.date]];
}

-(void)choose_date
{
    [self cancel_keyboard];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    self.Tdate.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datepick.date]];
}

-(IBAction)back_click:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(IBAction)submit_click:(id)sender
{
    NSString* Tselection=[self.selection titleForSegmentAtIndex:self.selection.selectedSegmentIndex];
    NSString* Tnotification=isnoti==true?@"Yes":@"No";
    
    if(self.Tname.hasText)
    {
        if(self.Ttime.hasText)
        {
            if([self check_selection])
            {
                NSLog(@"%@",Fdate);
                DB *db=[[DB alloc] init];
                
                if(isAdd)
                {
                    NSString* tid=[db addTask:self.Tname.text time:self.Ttime.text selection:Tselection date:Fdate notification:Tnotification];

                    [self ShowAlertwithTitle:@"Task Added" AndMesg:@""];
                    
                    if([Tselection isEqualToString:@"Date"] && [Tnotification isEqualToString:@"Yes"])
                    {
                        [self Addnotification:self.Tdate.text time:self.Ttime.text tid:tid];
                    }
                    else if([Tselection isEqualToString:@"Week"] && [Tnotification isEqualToString:@"Yes"])
                    {
                        [self CallNotification_forWeek:Fdate time:self.Ttime.text tid:tid];
                    }
                    
                    [self clearAll];
                }
                else
                {
                    [db updateTask:[taskmodel getTid] tname:self.Tname.text time:self.Ttime.text selection:Tselection date:Fdate notification:Tnotification];
                    [db deletetoHistory:[taskmodel getTid] date:[taskmodel getDate]];
                    
                    if([Tselection isEqualToString:@"Date"])
                    {
                        NSString *s=[taskmodel getStatus];
                        if(![Fdate isEqualToString:[taskmodel getDate]])
                        {
                            s=@"No";
                        }
                        
                        [db addtoHistory:[taskmodel getTid] name:self.Tname.text time:self.Ttime.text selection:Tselection date:Fdate status:s];
                    }
                    
                    [self remove_PreviousNot];
                    if([Tselection isEqualToString:@"Date"] && [Tnotification isEqualToString:@"Yes"])
                    {
                        [self Addnotification:self.Tdate.text time:self.Ttime.text tid:[taskmodel getTid]];
                    }
                    else if([Tselection isEqualToString:@"Week"] && [Tnotification isEqualToString:@"Yes"])
                    {
                        [self CallNotification_forWeek:Fdate time:self.Ttime.text tid:[taskmodel getTid]];
                    }
                    
                    [self ShowAlertandExit:@"Task Updated" AndMesg:@""];
                }
            }
        }
        else
        {
            [self ShowAlertwithTitle:@"Enter Task time" AndMesg:@""];
        }
    }
    else
    {
        [self ShowAlertwithTitle:@"Enter Task Name" AndMesg:@""];
    }
}

-(IBAction)remove_click:(id)sender
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Delete Task?" message:@"Task deleting will remove all the history related to the Task" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DB *db=[[DB alloc] init];
        [db deleteTask:[taskmodel getTid]];
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    UIAlertAction *no=[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:ok];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void)ShowAlertwithTitle:(NSString*)title AndMesg:(NSString*)Mesg
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:Mesg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void)ShowAlertandExit:(NSString*)title AndMesg:(NSString*)Mesg
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:Mesg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:NULL];
}


-(BOOL)check_selection
{
    Fdate=@"";
    int i=0;
    if(self.selection.selectedSegmentIndex==0)
    {
        if(isMon)
        {
            i++; [self addtoString:@"Monday"];
        }
        if(isTues)
        {
            i++; [self addtoString:@"Tuesday"];
        }
        if(isWed)
        {
            i++; [self addtoString:@"Wednesday"];
        }
        if(isThur)
        {
            i++; [self addtoString:@"Thursday"];
        }
        if(isFri)
        {
            i++; [self addtoString:@"Friday"];
        }
        if(isSat)
        {
            i++; [self addtoString:@"Saturday"];
        }
        if(isSun)
        {
            i++; [self addtoString:@"Sunday"];
        }
        
        if(i==0)
        {
            [self ShowAlertwithTitle:@"Select Atleast one day of the Week" AndMesg:@""];
            return false;
        }
    }
    else
    {
        if(!self.Tdate.hasText)
        {
            [self ShowAlertwithTitle:@"Enter Task Date" AndMesg:@""];
            return false;
        }
        else{
            Fdate=self.Tdate.text;
            return true;
        }
    }
    return true;
}

-(void)addtoString:(NSString*)value
{
    if(Fdate.length>0)
    {
        Fdate=[NSString stringWithFormat:@"%@,%@",Fdate,value];
    }
    else
    {
        Fdate=[NSString stringWithFormat:@"%@",value];
    }
}

-(void)clearAll
{
    isMon=isTues=isWed=isThur=isFri=isSat=isSun=isnoti=false;
    isnoti=false;
    self.Tname.text=@"";
    self.Ttime.text=@"";
    self.Tdate.text=@"";
    [self.Monday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [self.Tuesday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [self.Wednesday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [self.Thursday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [self.Friday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [self.Saturday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [self.Sunday setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [self.bell setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
    isAdd=true;
    Fdate=@"";
    self.selection.selectedSegmentIndex=0;
    [self weekselected];
}

-(void)loadDefault
{
    self.Tname.text=[taskmodel getName];
    self.Ttime.text=[taskmodel getTime];
    
    if([[taskmodel getNotification] isEqualToString:@"Yes"])
    {
        isnoti=true;
        [self.bell setImage:[UIImage imageNamed:@"bellring"] forState:UIControlStateNormal];
    }
    else
    {
        isnoti=false;
        [self.bell setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
    }
    
    if([[taskmodel getSelection] isEqualToString:@"Week"])
    {
        self.selection.selectedSegmentIndex=0;
        [self weekselected];
        [self loaddays];
    }
    else
    {
        self.selection.selectedSegmentIndex=1;
        [self dateselected];
        self.Tdate.text=[taskmodel getDate];
    }
}

-(void)loaddays
{
    NSString *date=[taskmodel getDate];
    if([date containsString:@"Sunday"])
    {
        [self sunday_click:self];
    }
    
    if([date containsString:@"Monday"])
    {
        [self monday_click:self];
    }
    
    if([date containsString:@"Tuesday"])
    {
        [self tuesday_click:self];
    }
    
    if([date containsString:@"Wednesday"])
    {
        [self wednesday_click:self];
    }
    
    if([date containsString:@"Thursday"])
    {
        [self thursday_click:self];
    }
    
    if([date containsString:@"Friday"])
    {
        [self friday_click:self];
    }
    
    if([date containsString:@"Saturday"])
    {
        [self saturday_click:self];
    }
}

-(void)Addnotification:(NSString*)date time:(NSString*)time tid:(NSString*)tid
{
    NSLog(@"date - %@",date);
    NSLog(@"time - %@",time);
    NSArray *temp = [date componentsSeparatedByString:@"/"];
    NSArray *temp2 = [time componentsSeparatedByString:@":"];
    NSLog(@"date - %lu",(unsigned long)temp.count);
    NSLog(@"time - %lu",(unsigned long)temp2.count);
    
    NSDate *dt=[[NSDate alloc] init];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *timeComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:dt];
    
    [timeComponents setHour:[temp2[0] intValue]];
    [timeComponents setMinute:[temp2[1] intValue]];
    [timeComponents setSecond:0];
    [timeComponents setYear:[temp[0] intValue]];
    [timeComponents setMonth:[temp[1] intValue]];
    [timeComponents setDay:[temp[2] intValue]];
    NSDate *dtFinal = [calendar dateFromComponents:timeComponents];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSString *fierDate = [formatter stringFromDate:dtFinal];
    NSLog(@"firedate - %@",fierDate);
    [self setupLocalNotifications:dtFinal dt:fierDate tid:tid];
}

-(void)CallNotification_forWeek:(NSString*)date time:(NSString*)time tid:(NSString*)tid
{
    if([date containsString:@"Sunday"])
    {
        [self Addnotification_forWeek:time tid:tid weekid:@"1"];
    }
    
    if([date containsString:@"Monday"])
    {
        [self Addnotification_forWeek:time tid:tid weekid:@"2"];
    }
    
    if([date containsString:@"Tuesday"])
    {
        [self Addnotification_forWeek:time tid:tid weekid:@"3"];
    }
    
    if([date containsString:@"Wednesday"])
    {
        [self Addnotification_forWeek:time tid:tid weekid:@"4"];
    }
    
    if([date containsString:@"Thursday"])
    {
        [self Addnotification_forWeek:time tid:tid weekid:@"5"];
    }
    
    if([date containsString:@"Friday"])
    {
        [self Addnotification_forWeek:time tid:tid weekid:@"6"];
    }
    
    if([date containsString:@"Saturday"])
    {
        [self Addnotification_forWeek:time tid:tid weekid:@"7"];
    }
}

-(void)Addnotification_forWeek:(NSString*)time tid:(NSString*)tid weekid:(NSString*)wid
{
    NSLog(@"time - %@",time);
    NSArray *temp2 = [time componentsSeparatedByString:@":"];
    
    NSDate *dt=[[NSDate alloc] init];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *timeComponents = [calendar components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday ) fromDate:dt];
    
    [timeComponents setHour:[temp2[0] intValue]];
    [timeComponents setMinute:[temp2[1] intValue]];
    [timeComponents setSecond:0];
    [timeComponents setWeekday:[wid intValue]];
    NSDate *dtFinal = [calendar dateFromComponents:timeComponents];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSString *fierDate = [formatter stringFromDate:dtFinal];
    NSLog(@"firedate - %@ %@",fierDate,wid);
    
    NSString *body=[NSString stringWithFormat:@"%@ %@",tid,time];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = dtFinal;
    localNotification.alertTitle=[NSString stringWithFormat:@"Task Reminder - %@",self.Tname.text];
    localNotification.alertBody= body;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval= NSWeekCalendarUnit;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"reminder" forKey:@"ukey"];
    localNotification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)setupLocalNotifications:(NSDate *)date dt:(NSString*)dt tid:(NSString*)tid
{
    NSString *body=[NSString stringWithFormat:@"%@ %@",tid,dt];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.alertTitle=[NSString stringWithFormat:@"Task Reminder - %@",self.Tname.text];
    localNotification.alertBody= body;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //    localNotification.repeatInterval= NSCalendarUnitDay;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"reminder" forKey:@"ukey"];
    localNotification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)remove_PreviousNot
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    NSLog(@"Not count-%lu",eventArray.count);
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"ukey"]];
        NSLog(@"not-%@",uid);
        if ([uid isEqualToString:@"reminder"])
        {
            NSString *body=oneEvent.alertBody;
            NSLog(@"body-%@",body);
            NSArray *temp2 = [body componentsSeparatedByString:@" "];
            NSLog(@"%@ - %@",temp2[0],[taskmodel getTid]);
            if([temp2[0] isEqualToString:[taskmodel getTid]])
            {
                NSLog(@"tid-%@ cancelled",temp2[0]);
                [app cancelLocalNotification:oneEvent];
            }
        }
    }
}

@end
