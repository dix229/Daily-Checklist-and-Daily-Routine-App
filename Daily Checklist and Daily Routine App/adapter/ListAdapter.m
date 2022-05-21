#import "ListAdapter.h"

@implementation ListAdapter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)bell_click:(id)sender {
    int count=[self.Pos intValue];
    TaskModel *tm=[self.Tmlist objectAtIndex:count];
    if([[tm getNotification] isEqualToString:@"Yes"])
    {
        [tm setNotification:@"No"];
        [self remove_PreviousNot];
    }
    else
    {
        [tm setNotification:@"Yes"];
        if([[tm getSelection] isEqualToString:@"Date"])
        {
            [self Addnotification:[tm getDate] time:[tm getTime] tid:[tm getTid]];
        }
        else{
            [self CallNotification_forWeek:[tm getDate] time:[tm getTime] tid:[tm getTid]];
        }
        
    }
    [self.Tmlist replaceObjectAtIndex:count withObject:tm];
    [self.Table reloadData];
    
    DB *db=[[DB alloc] init];
    [db updateTask:tm.getTid tname:tm.getName time:tm.getTime selection:tm.getSelection date:tm.getDate notification:tm.getNotification];
}

- (IBAction)check_click:(id)sender {
    
    int count=[self.Pos intValue];
    TaskModel *tm=[self.Tmlist objectAtIndex:count];
    DB *db=[[DB alloc] init];
    
    if([[tm getStatus] isEqualToString:@"Yes"])
    {
        [tm setStatus:@"No"];
        //if selection is date update to history
        //if selection is week delete entry
        if([[tm getSelection] isEqualToString:@"Date"])
        {
            [db updatetoHistory:tm.getTid name:tm.getName time:tm.getTime selection:tm.getSelection date:tm.getDate status:tm.getStatus];
        }
        else{
            [db deletetoHistory:tm.getTid date:self.Seldate];
        }
    }
    else
    {
        [tm setStatus:@"Yes"];
        //if selection is date update to history
        //if selection is week add entry
        if([[tm getSelection] isEqualToString:@"Date"])
        {
            [db updatetoHistory:tm.getTid name:tm.getName time:tm.getTime selection:tm.getSelection date:tm.getDate status:tm.getStatus];
        }
        else{
            [db addtoHistory:tm.getTid name:tm.getName time:tm.getTime selection:tm.getSelection date:self.Seldate status:tm.getStatus];
        }
    }
    [self.Tmlist replaceObjectAtIndex:count withObject:tm];
    [self.Table reloadData];
}

- (IBAction)more_click:(id)sender {
    int count=[self.Pos intValue];
    TaskModel *tm=[self.Tmlist objectAtIndex:count];
    
    SavedData *sd=[[SavedData alloc] init];
    [sd setTask:tm];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *site = [mainStoryboard instantiateViewControllerWithIdentifier:@"Task"];
        [self.vc presentViewController:site animated:YES completion:nil];
    });
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

- (void)setupLocalNotifications:(NSDate *)date dt:(NSString*)dt tid:(NSString*)tid
{
    int count=[self.Pos intValue];
    TaskModel *tm=[self.Tmlist objectAtIndex:count];
    
    NSString *body=[NSString stringWithFormat:@"%@ %@",tid,dt];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.alertTitle=[NSString stringWithFormat:@"Task Reminder - %@",[tm getName]];
    localNotification.alertBody= body;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //    localNotification.repeatInterval= NSCalendarUnitDay;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"reminder" forKey:@"ukey"];
    localNotification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
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
    int count=[self.Pos intValue];
    TaskModel *tm=[self.Tmlist objectAtIndex:count];
    
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
    NSLog(@"firedate - %@",fierDate);
    
    NSString *body=[NSString stringWithFormat:@"%@ %@",tid,time];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = dtFinal;
    localNotification.alertTitle=[NSString stringWithFormat:@"Task Reminder - %@",[tm getName]];
    localNotification.alertBody= body;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval= NSCalendarUnitWeekday;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"reminder" forKey:@"ukey"];
    localNotification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)remove_PreviousNot
{
    int count=[self.Pos intValue];
    TaskModel *tm=[self.Tmlist objectAtIndex:count];
    
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
            NSLog(@"%@ - %@",temp2[0],[tm getTid]);
            if([temp2[0] isEqualToString:[tm getTid]])
            {
                NSLog(@"tid-%@ cancelled",temp2[0]);
                [app cancelLocalNotification:oneEvent];
            }
        }
    }
}
@end
