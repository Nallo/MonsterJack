//
//  MonsterDetailStaticTVC.m
//  MonsterJack
//
//  Created by stefano on 05/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "MonsterDetailStaticTVC.h"
#import "Monster.h"
#import "MonsterTVController.h"

@interface MonsterDetailStaticTVC ()

@property (strong, nonatomic) IBOutlet UIImageView *monsterImage;
@property (strong, nonatomic) IBOutlet UILabel *monsterIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *monsterNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *monsterExpLabel;
@property (strong, nonatomic) IBOutlet UILabel *monsterColorLabel;
@property (strong, nonatomic) IBOutlet UILabel *membersLabel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *freeButton;

@property (strong, nonatomic) IBOutlet UITableViewCell *imageCell;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *detailCellCollection;

@end

@implementation MonsterDetailStaticTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _monster.name;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setBackgroundView:[[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"game_bg"]]];
    [self setCellsTrasparent];
}

-(void)setCellsTrasparent{
    
    _imageCell.backgroundColor = [UIColor clearColor];
    for (UITableViewCell *cell in _detailCellCollection) {
        cell.backgroundColor = [UIColor clearColor];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fillLabels];
}

- (IBAction)freePressed:(id)sender {
    [self showAlert];
}

-(void)showAlert
{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Free!" message:@"Are you sure to free the monster?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    
    [alert show];
    
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self performSegueWithIdentifier:@"freeMonster" sender:self];
    }
}

-(void)fillLabels
{

    _monsterExpLabel.text = [NSString stringWithFormat:@"Exp point needed:\t\t%d", (int)_monster.expPoint];
    _monsterNameLabel.text = [NSString stringWithFormat:@"Name:\t\t\t\t\t%@", _monster.name];
    _monsterIdLabel.text = [NSString stringWithFormat:@"#%d", (int)_monster.identifier];
    _monsterColorLabel.text = [NSString stringWithFormat:@"Color:\t\t\t\t\t%@",_monster.colorName];
    if(!_monster.groupMembers)
        _membersLabel.text = [NSString stringWithFormat:@"Hunter needed:\t\tnobody"];
    else
        _membersLabel.text = [NSString stringWithFormat:@"Hunters needed:\t\t%d",_monster.groupMembers];
    
    if(_monster.isCatched){
        _monsterImage.image = _monster.image;
        self.freeButton.enabled = YES;
    } else {
        _monsterImage.image = [self imageBW:_monster.image];
        self.freeButton.enabled = NO;
    }
    
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

#pragma mark - navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.monster.catched = NO;
}

@end
