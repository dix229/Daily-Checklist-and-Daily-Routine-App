#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskModel : NSObject
{
    NSString *tid,*name,*time,*selection,*date,*notification,*status;
}

-(id)init:(NSString*)_tid tname:(NSString*)_tname time:(NSString*)_time selection:(NSString*)_selection date:(NSString*)_date notification:(NSString*)_notification status:(NSString*)_status;

-(NSString*)getTid;
-(NSString*)getName;
-(NSString*)getTime;
-(NSString*)getSelection;
-(NSString*)getDate;
-(NSString*)getNotification;
-(NSString*)getStatus;

-(void)setTid:(NSString*)_tid;
-(void)setName:(NSString*)_tname;
-(void)setTime:(NSString*)_time;
-(void)setSelection:(NSString*)_selection;
-(void)setDate:(NSString*)_date;
-(void)setNotification:(NSString*)_notification;
-(void)setStatus:(NSString*)_status;

@end

NS_ASSUME_NONNULL_END
