#import "Home.h"

@interface Home ()

@end

@implementation Home

UIColor *greenColor;
NSMutableArray *dates,*datetxt,*daytxt,*dateview,*dateobj;
NSMutableArray *Tmlist;
int defpos;

- (void)viewDidLoad {
    [super viewDidLoad];
    defpos=-1;
    [self viewinit];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self createdates];
}

-(void)viewinit
{
    DB *db=[[DB alloc] init];
    [db InitializeDB];
    greenColor = [UIColor colorWithRed:93/255.0f green:203/255.0f blue:154/255.0f alpha:1.0f];
}

-(IBAction)mon_click:(id)sender
{
    [self LoadData:0];
}

-(IBAction)tue_click:(id)sender{
    [self LoadData:1];
}

-(IBAction)wed_click:(id)sender{
   [self LoadData:2];
}

-(IBAction)thu_click:(id)sender{
    [self LoadData:3];
}

-(IBAction)fri_click:(id)sender{
    [self LoadData:4];
}

-(IBAction)sat_click:(id)sender{
    [self LoadData:5];
}

-(IBAction)sun_click:(id)sender{
   [self LoadData:6];
}

-(void)clearAll
{
    [self.monV setBackgroundColor:[UIColor clearColor]];
    [self.tueV setBackgroundColor:[UIColor clearColor]];
    [self.wedV setBackgroundColor:[UIColor clearColor]];
    [self.thuV setBackgroundColor:[UIColor clearColor]];
    [self.friV setBackgroundColor:[UIColor clearColor]];
    [self.satV setBackgroundColor:[UIColor clearColor]];
    [self.sunV setBackgroundColor:[UIColor clearColor]];
}

-(void)createdates
{
    dateobj=[[NSMutableArray alloc] init];
    dates=[[NSMutableArray alloc] init];
    datetxt=[[NSMutableArray alloc] init];
    daytxt=[[NSMutableArray alloc] init];
    dateview=[[NSMutableArray alloc] init];
    NSDateFormatter *sdf=[[NSDateFormatter alloc] init];
    NSDate *mydate = [NSDate date];
    [datetxt addObject:self.monD];[datetxt addObject:self.tueD];[datetxt addObject:self.wedD];[datetxt addObject:self.thuD];
    [datetxt addObject:self.friD];[datetxt addObject:self.satD];[datetxt addObject:self.sunD];
    
    [dateview addObject:self.monV];[dateview addObject:self.tueV];[dateview addObject:self.wedV];[dateview addObject:self.thuV];[dateview addObject:self.friV];[dateview addObject:self.satV];[dateview addObject:self.sunV];
    
    [daytxt addObject:@"Monday"];[daytxt addObject:@"Tuesday"];[daytxt addObject:@"Wednesday"];[daytxt addObject:@"Thursday"];[daytxt addObject:@"Friday"];[daytxt addObject:@"Saturday"];[daytxt addObject:@"Sunday"];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth fromDate:[NSDate date]];
    int week=[comp weekday];
    int year=[comp year];
    int month=[comp month];
    int monthweek=[comp weekOfMonth];
    
    int arrcount=0;
    for(int i=2;i<=7;i++)
    {
        NSCalendar *gregorian1 = [NSCalendar currentCalendar];
        NSDateComponents *comps1 = [gregorian1 components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday fromDate:mydate];
        
        [comps1 setYear:year];
        [comps1 setMonth:month];
        [comps1 setWeekOfMonth:monthweek];
        [comps1 setWeekday:i];
        
        NSDate *resultDate = [gregorian1 dateFromComponents:comps1];
        [sdf setDateFormat:@"yyyy/MM/dd"];
        [dates addObject:[sdf stringFromDate:resultDate]];
        [dateobj addObject:resultDate];
        
        [sdf setDateFormat:@"dd/MM"];
        UILabel *date=[datetxt objectAtIndex:arrcount];
        date.text=[sdf stringFromDate:resultDate];
        
        arrcount++;
        if(i==7)
        {
            [comps1 setYear:year];
            [comps1 setMonth:month];
            [comps1 setWeekOfMonth:monthweek+1];
            [comps1 setWeekday:1];
            
            NSDate *resultDate = [gregorian1 dateFromComponents:comps1];
            [sdf setDateFormat:@"yyyy/MM/dd"];
            [dates addObject:[sdf stringFromDate:resultDate]];
            
            [sdf setDateFormat:@"dd/MM"];
            UILabel *date=[datetxt objectAtIndex:arrcount];
            date.text=[sdf stringFromDate:resultDate];
            [dateobj addObject:resultDate];
        }
    }
    
    [sdf setDateFormat:@"EEEE"];
    if(defpos==-1)
    {
        [self loaddefault:[sdf stringFromDate:mydate]];
    }
    else
    {
        [self LoadData:defpos];
    }
}

-(void)loaddefault:(NSString*)day
{
    int count=0;
    for(int i=0;i<daytxt.count;i++)
    {
        if([day isEqualToString:[daytxt objectAtIndex:i]])
        {
            count=i;
            break;
        }
    }
    [self LoadData:count];
}

-(void)LoadData:(int)pos
{
    defpos=pos;
    [self clearAll];
    UIView *v=[dateview objectAtIndex:pos];
    [v setBackgroundColor:greenColor];
    
    self.Table.dataSource=nil;
    [self.Table reloadData];
        
    DB *db=[[DB alloc] init];
    NSLog(@"date-%@",[dates objectAtIndex:pos]);
    NSLog(@"day-%@",[daytxt objectAtIndex:pos]);
    
    Tmlist=[db getalldata:[dates objectAtIndex:pos] day:[daytxt objectAtIndex:pos]];
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

-(IBAction)add_click:(id)sender
{
    SavedData *sd=[[SavedData alloc] init];
    [sd setTask:nil];
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Task"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(IBAction)cal_click:(id)sender
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskHistory"];
    [self presentViewController:vc animated:YES completion:nil];
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
    cell.Seldate=[dates objectAtIndex:defpos];
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
        
        if(![[sdf stringFromDate:mydate] isEqualToString:[dates objectAtIndex:defpos]])
        {
            NSComparisonResult result1 = [mydate compare:[dateobj objectAtIndex:defpos]];
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
