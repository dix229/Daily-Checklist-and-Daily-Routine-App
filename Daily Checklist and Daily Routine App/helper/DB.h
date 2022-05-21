#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TaskModel.h"

NS_ASSUME_NONNULL_BEGIN

NSString *dbfilepath;
sqlite3  *db;

@interface DB : NSObject

-(void)InitializeDB;
-(NSString*)getPath;

-(NSString*)addTask:(NSString*)tname time:(NSString*)time selection:(NSString*)selection date:(NSString*)date notification:(NSString*)notification;

- (void)updateTask:(NSString*)tid tname:(NSString*)tname time:(NSString*)time selection:(NSString*)selection date:(NSString*)date notification:(NSString*)notification;

- (void)deleteTask:(NSString*)tid;

-(void)addtoHistory:(NSString*)tid name:(NSString*)name time:(NSString*)time selection:(NSString*)selection date:(NSString*)date status:(NSString*)status;

-(void)updatetoHistory:(NSString*)tid name:(NSString*)name time:(NSString*)time selection:(NSString*)selection date:(NSString*)date status:(NSString*)status;

-(void)deletetoHistory:(NSString*)tid date:(NSString*)date;

-(NSMutableArray*)getalldata:(NSString*)date day:(NSString*)day;

-(NSMutableArray*)getall;

@end

NS_ASSUME_NONNULL_END
