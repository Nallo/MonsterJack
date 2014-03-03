//
//  StatisticsVC.m
//  MonsterJack
//
//  Created by stefano on 04/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "StatisticsVC.h"
#import "GameManager.h"

@interface StatisticsVC ()

@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *catchedLabel;


@end

@implementation StatisticsVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    
    if(![_gameManager playerCreated]){
        [self showAlert];
    } else {
        [self fillLabels];
        NSLog(@"all right");
    }

	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fillLabels];
    NSLog(@"stat will appear");
}

- (IBAction)changeName:(id)sender {
    [self showAlert];
}

- (IBAction)eraseData:(id)sender
{
    [self deleteUserFile];
    _gameManager.playerCreated = NO;
    [self showAlert];
}

-(void)deleteUserFile
{
    [_gameManager deleteUserFile];
}

-(void)fillLabels
{
    _playerNameLabel.text = [NSString stringWithFormat:@"Name: %@",_gameManager.getPlayerName];
    _scoreLabel.text = [NSString stringWithFormat:@"Experience: %d",(unsigned int)_gameManager.getExperience];
    _catchedLabel.text = [NSString stringWithFormat:@"Catched: %d monsters", (int)_gameManager.getCatchedCount];
}

/* it shows the alert */
-(void)showAlert
{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter your name:" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"Enter your name";
    [alert show];

}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView*)alertView
{
    if(alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput ||
       alertView.alertViewStyle == UIAlertViewStylePlainTextInput ||
       alertView.alertViewStyle == UIAlertViewStyleSecureTextInput)
    {
        NSString* text = [[alertView textFieldAtIndex:0] text];
        return ([text length] > 0);
    }
    else if (alertView.alertViewStyle == UIAlertViewStyleDefault)
        return true;
    else
        return false;
}

/* called when the Ok button of the alert is pressed */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*
    if (![[[alertView textFieldAtIndex:0] text] length]) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [self showAlert];
        NSLog(@"empty");
    }
    */
    [_gameManager setPlayerName:[[alertView textFieldAtIndex:0] text]];
    NSLog(@"%@",[_gameManager getPlayerName]);
    [self fillLabels];
}

-(void)initialize
{
    if(!_gameManager)
        _gameManager = [[GameManager alloc] init];

}

@end
