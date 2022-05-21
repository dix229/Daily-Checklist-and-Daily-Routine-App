#import "SavedData.h"

@implementation SavedData

-(void)setTask:(TaskModel*)tm
{
    taskmodel=tm;
}

-(TaskModel*)getTask
{
    return taskmodel;
}

@end
