#import <Foundation/Foundation.h>
#import "TaskModel.h"

NS_ASSUME_NONNULL_BEGIN

TaskModel *taskmodel;

@interface SavedData : NSObject

-(void)setTask:(TaskModel*)tm;
-(TaskModel*)getTask;

@end

NS_ASSUME_NONNULL_END
