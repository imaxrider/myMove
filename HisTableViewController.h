//
//  UIViewController+HisTable.h
//  myMove
//
//  Created by smartax on 9/1/15.
//  Copyright (c) 2015 Rachanon Kwampien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "HistoryViewController.h"
@interface HisTableViewController:UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    sqlite3 * db;
    NSString * Meter0,*Meter1,*Meter2,*Meter3,*Meter4,*Meter5,*Meter6,*Meter7;
    NSString * strAllData;
    NSMutableArray * dataArray;
    IBOutlet UITableView * myTable;
}
@end
