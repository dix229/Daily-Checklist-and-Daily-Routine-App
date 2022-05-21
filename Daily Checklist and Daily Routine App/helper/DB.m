#import "DB.h"

@implementation DB

-(void)InitializeDB
{
    NSString * DocsDir;
    NSArray *Dirpath;
    Dirpath= NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    DocsDir=Dirpath[0];
    
    dbfilepath=[[NSString alloc] initWithString:[DocsDir stringByAppendingPathComponent:@"DailyTask.db"]];
    
    NSFileManager *filemgr=[NSFileManager defaultManager];
    
    if([filemgr fileExistsAtPath:dbfilepath]==NO)
    {
        const char *dbpath=[dbfilepath UTF8String];
        
        if(sqlite3_open(dbpath, & db)==SQLITE_OK)
        {
            char  *errormesg;
            
            const char *sqlstatement="CREATE TABLE IF NOT EXISTS TASK (TID INTEGER PRIMARY KEY AUTOINCREMENT,TNAME TEXT,TTIME TEXT,SELECTION TEXT,TDATE TEXT,ISNOTI TEXT)";
            
            if(sqlite3_exec(db, sqlstatement, NULL, NULL, &errormesg)!=SQLITE_OK)
            {
                NSLog(@"task-error");
            }
            else
            {
                NSLog(@"task-created");
            }
            
            const char *sqlstatement1="CREATE TABLE IF NOT EXISTS TASKHISTORY (TID TEXT,TNAME TEXT,TTIME TEXT,SELECTION TEXT,TDATE TEXT,STATUS TEXT)";
            
            if(sqlite3_exec(db, sqlstatement1, NULL, NULL, &errormesg)!=SQLITE_OK)
            {
                NSLog(@"taskhistory-error");
            }
            else
            {
                NSLog(@"taskhistory-created");
            }
            
            sqlite3_close(db);
        }
        else
        {
            NSLog(@"Error Opening database");
        }
    }
    else
    {
        NSLog(@"File Exits");
    }
}

-(NSString*)getPath
{
    NSString * DocsDir;
    NSArray *Dirpath;
    
    Dirpath= NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    DocsDir=Dirpath[0];
    
    dbfilepath=[[NSString alloc] initWithString:[DocsDir stringByAppendingPathComponent:@"DailyTask.db"]];
    return dbfilepath;
}

-(NSString*)addTask:(NSString*)tname time:(NSString*)time selection:(NSString*)selection date:(NSString*)date notification:(NSString*)notification
{
    NSString *s=@"";
    [self getPath];
    sqlite3_stmt *statement;
    const char*dbpath=[dbfilepath UTF8String];
    
    if(sqlite3_open(dbpath, &db)==SQLITE_OK)
    {
        NSString *insertstmt=[NSString stringWithFormat:@"INSERT INTO TASK(TNAME,TTIME,SELECTION,TDATE,ISNOTI)  VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",tname,time,selection,date,notification];
        
        const char *insert=[insertstmt UTF8String];
        sqlite3_prepare_v2(db, insert, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"INSERT_TASK SUCCESS");
        }
        else
        {
            NSLog(@"INSERT_TASK ERROR");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
        
        NSString *tid=[self getId];
        s=tid;
        
        if([selection isEqualToString:@"Date"])
        {
            [self addtoHistory:tid name:tname time:time selection:selection date:date status:@"No"];
        }
    }
    return s;
}


- (void)updateTask:(NSString*)tid tname:(NSString*)tname time:(NSString*)time selection:(NSString*)selection date:(NSString*)date notification:(NSString*)notification
{
    
    [self getPath];
    sqlite3_stmt *statement;
    const char*dbpath=[dbfilepath UTF8String];
    
    if(sqlite3_open(dbpath, &db)==SQLITE_OK)
    {
        NSString *insertstmt=[NSString stringWithFormat:@"UPDATE TASK SET TNAME=\"%@\", TTIME=\"%@\", SELECTION=\"%@\", TDATE=\"%@\",ISNOTI=\"%@\" where TID=\"%@\"",tname,time,selection,date,notification,tid];
        
        const char *insert=[insertstmt UTF8String];
        sqlite3_prepare_v2(db, insert, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"UPDATE_TASK SUCCESS");
        }
        else
        {
            NSLog(@"UPDATE_TASK ERROR");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
}

- (void)deleteTask:(NSString*)tid
{
    
    [self getPath];
    sqlite3_stmt *statement;
    const char*dbpath=[dbfilepath UTF8String];
    
    if(sqlite3_open(dbpath, &db)==SQLITE_OK)
    {
        NSString *insertstmt=[NSString stringWithFormat:@"DELETE FROM TASK where TID=\"%@\"",tid];
        
        const char *insert=[insertstmt UTF8String];
        sqlite3_prepare_v2(db, insert, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"DELETE_TASK SUCCESS");
        }
        else
        {
            NSLog(@"DELETE_TASK ERROR");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
}

-(NSString*)getId
{
    [self getPath];
    
    NSString *tid=@"";
    sqlite3_stmt *statement;
    const char *dbpath=[dbfilepath UTF8String];
    
    if(sqlite3_open(dbpath, &db)==SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"Select TID from TASK order by TID DESC LIMIT 1"];
        const char *finalquery=[query UTF8String];
        
        if(sqlite3_prepare_v2(db, finalquery, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                tid=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            };
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return tid;
}

-(void)addtoHistory:(NSString*)tid name:(NSString*)name time:(NSString*)time selection:(NSString*)selection date:(NSString*)date status:(NSString*)status
{
    [self getPath];
    
    sqlite3_stmt *statement;
    const char*dbpath=[dbfilepath UTF8String];
    
    if(sqlite3_open(dbpath, &db)==SQLITE_OK)
    {
        NSString *insertstmt=[NSString stringWithFormat:@"INSERT INTO TASKHISTORY  VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",tid,name,time,selection,date,status];
        
        const char *insert=[insertstmt UTF8String];
        sqlite3_prepare_v2(db, insert, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"INSERT_TASKHISTORY SUCCESS");
        }
        else
        {
            NSLog(@"INSERT_TASKHISTORY ERROR");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
}

// const char *sqlstatement="CREATE TABLE IF NOT EXISTS TASK (TID INTEGER PRIMARY KEY AUTOINCREMENT,TNAME TEXT,TTIME TEXT,SELECTION TEXT,TDATE TEXT,ISNOTI TEXT)";
//
//   const char *sqlstatement1="CREATE TABLE IF NOT EXISTS TASKHISTORY (TID TEXT,TNAME TEXT,TTIME TEXT,SELECTION TEXT,TDATE TEXT,STATUS TEXT)";

// NSString *tid,*name,*time,*selection,*date,*notification,*status;

-(void)updatetoHistory:(NSString*)tid name:(NSString*)name time:(NSString*)time selection:(NSString*)selection date:(NSString*)date status:(NSString*)status
{
    [self getPath];
    
    sqlite3_stmt *statement;
    const char*dbpath=[dbfilepath UTF8String];
    
    if(sqlite3_open(dbpath, &db)==SQLITE_OK)
    {
        NSString *insertstmt=[NSString stringWithFormat:@"UPDATE TASKHISTORY SET TNAME=\"%@\", TTIME=\"%@\", SELECTION=\"%@\",STATUS=\"%@\" where TID=\"%@\" AND TDATE=\"%@\"",name,time,selection,status,tid,date];
        
        const char *insert=[insertstmt UTF8String];
        sqlite3_prepare_v2(db, insert, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"UPDATE_TASKHISTORY SUCCESS");
        }
        else
        {
            NSLog(@"UPDATE_TASKHISTORY ERROR");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
}

-(void)deletetoHistory:(NSString*)tid date:(NSString*)date
{
    [self getPath];
    
    sqlite3_stmt *statement;
    const char*dbpath=[dbfilepath UTF8String];
    
    if(sqlite3_open(dbpath, &db)==SQLITE_OK)
    {
        NSString *insertstmt=[NSString stringWithFormat:@"DELETE FROM TASKHISTORY where TID=\"%@\" AND TDATE=\"%@\"",tid,date];
        
        const char *insert=[insertstmt UTF8String];
        sqlite3_prepare_v2(db, insert, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"DELETE_TASKHISTORY SUCCESS");
        }
        else
        {
            NSLog(@"DELETE_TASKHISTORY ERROR");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
}


-(NSMutableArray*)getalldata:(NSString*)date day:(NSString*)day
{
    [self getPath];
    
    NSMutableArray *tmlist=[[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath=[dbfilepath UTF8String];
    
    if(sqlite3_open(dbpath, &db)==SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"select t.*,ifnull((select STATUS from TASKHISTORY where TDATE='%@' AND TID=t.TID),'No') from TASK t where (t.TDATE='%@' OR t.TDATE LIKE '%%%@%%') order by t.TTIME",date,date,day];
        const char *finalquery=[query UTF8String];
        
        if(sqlite3_prepare_v2(db, finalquery, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                int count=sqlite3_data_count(statement);
                
                NSString *tid=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *name=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *time=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *selection=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *date=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *noti=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *status=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                
                TaskModel *tm=[[TaskModel alloc] init:tid tname:name time:time selection:selection date:date notification:noti status:status];
                [tmlist addObject:tm];
            };
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
    return tmlist;
}

-(NSMutableArray*)getall
{
    [self getPath];
    NSMutableArray *tmlist=[[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath=[dbfilepath UTF8String];
    
    if(sqlite3_open(dbpath, &db)==SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"select * from TASK"];
        const char *finalquery=[query UTF8String];
        
        if(sqlite3_prepare_v2(db, finalquery, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                int count=sqlite3_data_count(statement);
                NSString *tid=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *name=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *time=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *selection=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *date=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *noti=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *status=@"No";
                
                TaskModel *tm=[[TaskModel alloc] init:tid tname:name time:time selection:selection date:date notification:noti status:status];
                [tmlist addObject:tm];
            };
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
    return tmlist;
}



@end
