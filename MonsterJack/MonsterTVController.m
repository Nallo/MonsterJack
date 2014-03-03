//
//  MonsterTVController.m
//  MonsterJack
//
//  Created by stefano on 05/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "MonsterTVController.h"
#import "MonsterCollection.h"
#import "MonsterTVCell.h"
#import "MonsterDetailStaticTVC.h"

@interface MonsterTVController ()

@end

@implementation MonsterTVController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setBackgroundView:[[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"game_bg"]]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
    NSLog(@"list will appear");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_monsterCollection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MonsterCell";
    MonsterTVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    if(![[_monsterCollection monsterByIdentifier:indexPath.row] isCatched]){
        cell.monsterImage.image = [self imageBW:[[_monsterCollection monsterByIdentifier:indexPath.row] image]];        
    } else {
        cell.monsterImage.image = [[_monsterCollection monsterByIdentifier:indexPath.row] image];
    }
    cell.monsterNameLabel.text = [[_monsterCollection monsterByIdentifier:indexPath.row] name];
    cell.monsterExpLabel.text = [NSString stringWithFormat:@"%d exp",(int)[[_monsterCollection monsterByIdentifier:indexPath.row] expPoint]];
    
    return cell;
}

-(UIImage*)imageBW:(UIImage*)image
{
    UIImage *originalImage = image;
    
    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, originalImage.size.width, originalImage.size.height, 8, originalImage.size.width, colorSapce, (CGBitmapInfo)kCGImageAlphaOnly);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, originalImage.size.width, originalImage.size.height), [originalImage CGImage]);
    
    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSapce);
    
    return [UIImage imageWithCGImage:bwImage]; // This is result B/W image.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        if ([segue.destinationViewController isKindOfClass:[MonsterDetailStaticTVC class]]) {
            MonsterDetailStaticTVC *staticDetailVC = (MonsterDetailStaticTVC*) segue.destinationViewController;
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            staticDetailVC.monster = [_monsterCollection monsterByIdentifier:indexPath.row];
        }
    }
    
}

- (IBAction)unwindFreeMonster:(UIStoryboardSegue*)sender{

    [self.tableView reloadData];
   
}

@end
