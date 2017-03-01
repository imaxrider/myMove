//
//  UIViewController+HisTable.m
//  myMove
//
//  Created by smartax on 9/1/15.
//  Copyright (c) 2015 Rachanon Kwampien. All rights reserved.
//

#import "HisTableViewController.h"

@implementation HisTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self openDB];
    dataArray = [[NSMutableArray alloc]init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM savemove"];
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            char *field0 = (char *)sqlite3_column_text(statement, 0);
            Meter0 =[[NSString alloc]initWithUTF8String:field0];
            
            char *field1 = (char *)sqlite3_column_text(statement, 1);
            Meter1 =[[NSString alloc]initWithUTF8String:field1];
            
            char *field2 = (char *)sqlite3_column_text(statement, 2);
            Meter2 =[[NSString alloc]initWithUTF8String:field2];
            
            char *field3 = (char *)sqlite3_column_text(statement, 3);
            Meter3 =[[NSString alloc]initWithUTF8String:field3];
            
            char *field4 = (char *)sqlite3_column_text(statement, 4);
            Meter4 =[[NSString alloc]initWithUTF8String:field4];
            
            char *field5 = (char *)sqlite3_column_text(statement, 5);
            Meter5 =[[NSString alloc]initWithUTF8String:field5];
            
            char *field6 = (char *)sqlite3_column_text(statement, 6);
            Meter6 =[[NSString alloc]initWithUTF8String:field6];
            
            char *field7 = (char *)sqlite3_column_text(statement, 7);
            Meter7 =[[NSString alloc]initWithUTF8String:field7];
            
            strAllData = [[NSString alloc]initWithFormat:@"%@,Distance : %@ km,Time : %@ min,%@,%@,^%@^%@",Meter1,Meter2,Meter3,Meter4,Meter5,Meter6,Meter7];
            [dataArray addObject:strAllData];
        }
    }
    [myTable setDelegate:self];
    [myTable setDataSource:self];
    [myTable reloadData];
}
-(NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0]stringByAppendingPathComponent:@"dbMove.sql"];
}
-(void)openDB
{
    if (sqlite3_open([[self filePath]UTF8String],&db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Database Error");
        NSLog(@"Database Error");
    }else
    {
        NSLog(@"database open");
    }
}
-(void)DeleteData
{
    NSString *qsql = [NSString stringWithFormat:@"DELETE FROM savemove WHERE ID = %@",Meter0];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2( db, [qsql UTF8String], -1,
                           &statement, NULL) == SQLITE_OK)
        while (sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"deleted %@",Meter0);
        }
    else {
        sqlite3_close(db);
        NSAssert(0, @"Failed to Delete");
    }
    sqlite3_finalize(statement);
}
-(IBAction)Back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    sqlite3_close(db);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    [myTable reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *dataTitle = [NSString stringWithFormat:@"History"];
    return dataTitle;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"TT %lu",(unsigned long)[dataArray count]);
    return [dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIden =@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIden forIndexPath:indexPath];
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleDefault
                                      reuseIdentifier : CellIden];
        [cell setExclusiveTouch:NO];
    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //[tableView beginUpdates];
        [self DeleteData];
        [dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryViewController * HistoryView = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryView"];
    HistoryView.moveData = [dataArray[indexPath.row] description];
    [self presentViewController:HistoryView animated:YES completion:nil];
}
- (IBAction)editButton:(id)sender
{
    NSLog(@"Edit History");
    [myTable setEditing:!myTable.editing animated:YES];
}
@end
