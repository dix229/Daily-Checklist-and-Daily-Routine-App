#import "TaskModel.h"

@implementation TaskModel

-(id)init:(NSString*)_tid tname:(NSString*)_tname time:(NSString*)_time selection:(NSString*)_selection date:(NSString*)_date notification:(NSString*)_notification status:(NSString*)_status
{
    if(self = [super init])
    {
    tid=_tid;
    name=_tname;
    time=_time;
    selection=_selection;
    date=_date;
    notification=_notification;
    status=_status;
    }
    
    return self;
}

-(NSString*)getTid
{
    return tid;
}

-(NSString*)getName
{
    return name;
}

-(NSString*)getTime{
    return time;
}

-(NSString*)getSelection{
    return selection;
}

-(NSString*)getDate{
    return date;
}

-(NSString*)getNotification{
    return notification;
}

-(NSString*)getStatus{
    return status;
}

-(void)setTid:(NSString*)_tid
{
    tid=_tid;
}

-(void)setName:(NSString*)_tname{
    name=_tname;
}

-(void)setTime:(NSString*)_time{
    time=_time;
}

-(void)setSelection:(NSString*)_selection{
    selection=_selection;
}

-(void)setDate:(NSString*)_date{
    date=_date;
}

-(void)setNotification:(NSString*)_notification{
    notification=_notification;
}

-(void)setStatus:(NSString*)_status{
    status=_status;
}


@end
