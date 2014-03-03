//
//  GroupHuntingVC.m
//  MonsterJack
//
//  Created by stefano on 11/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "GroupHuntingVC.h"
#import "ListMembersTVC.h"
#import "GameManager.h"

@interface GroupHuntingVC ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSArray *pickerValues;

@property (nonatomic) NSInteger pickerSelection;

@end

@implementation GroupHuntingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_bg"]];
    [self.view addSubview:bgImage];
    [self.view sendSubviewToBack:bgImage];
    [self initialize];
    
	// Do any additional setup after loading the view.
}

-(void)initialize
{
    if (!_pickerValues) {
        _pickerValues = @[@"select value",@"2",@"3",@"4"];
    }
    _titleLabel.font = [UIFont fontWithName:@"Homestead-Inline" size:25];
}

#pragma mark - picker delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if ([_pickerValues[row] isEqualToString:@"select value"]) {
        _pickerSelection = 0;
        NSLog(@"select value");
    } else {
        _pickerSelection = [_pickerValues[row] integerValue];
        NSLog(@"%d",(int)_pickerSelection);
    }
}

#pragma mark - picker data source

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerValues.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerValues[row];
}

#pragma mark - alert

-(void)showAlert
{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please select a value." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    
    [alert show];
    
}

#pragma mark - navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (!_pickerSelection) {
        [self showAlert];
        return NO;
    } else {
        return YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"getMembers"]) {
        if ([segue.destinationViewController isKindOfClass:[ListMembersTVC class]]) {
            ListMembersTVC *listMembersTVC = (ListMembersTVC*) segue.destinationViewController;
            listMembersTVC.numberOfMembers = _pickerSelection;
            listMembersTVC.playerName = [_gameManager getPlayerName];
            listMembersTVC.expPoints = [_gameManager getExperience];
            listMembersTVC.gameManager = self.gameManager;
        }
    }
}

@end
