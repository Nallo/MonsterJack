//
//  StatisticsStaticTVC.m
//  MonsterJack
//
//  Created by stefano on 06/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "StatisticsStaticTVC.h"
#import "GameManager.h"
#import "Monster.h"
#import "MonsterCollection.h"


@interface StatisticsStaticTVC ()

@property (strong, nonatomic) IBOutlet UILabel *namePlayerLabel;
@property (strong, nonatomic) IBOutlet UILabel *expLabel;
@property (strong, nonatomic) IBOutlet UILabel *catchedLabel;

@property (strong, nonatomic) IBOutlet UIImageView *imagePlayer;
@property (strong, nonatomic) UIImagePickerController *picker;

@property (strong, nonatomic) IBOutlet UITableViewCell *mainCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *buttonCell;

@end

@implementation StatisticsStaticTVC


- (IBAction)pickOne {
    
    NSLog(@"pressed");

}

- (IBAction)choosePhoto:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        _imagePlayer.image = image;
        [_gameManager saveImage:image];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fillLabels];
    NSLog(@"stat will appear");
}


- (IBAction)eraseData:(id)sender {

    [self showAlert];
    [self deleteUserFile];
    [self resetAllValues];
    
}

- (IBAction)editName:(id)sender {
    
    [self showAlert];

}

-(void)resetAllValues
{
    MonsterCollection *monsterCollection = [_gameManager getMonsterCollection];
    NSArray *array = [monsterCollection allMonsters];
    for (Monster *monster in array) {
        monster.catched = NO;
    }
    
}

-(void)deleteUserFile
{
    [_gameManager deleteUserFile];
}

-(void)fillLabels
{
    _namePlayerLabel.text = [NSString stringWithFormat:@"%@",_gameManager.getPlayerName];
    _expLabel.text = [NSString stringWithFormat:@"%d",(unsigned int)_gameManager.getExperience];
    _catchedLabel.text = [NSString stringWithFormat:@"%d", (unsigned int)_gameManager.getCatchedCount];
    
    _imagePlayer.image = [_gameManager loadImage];
    
}

-(void)getImageFromLibrary
{
    
}


/* it shows the alert */
-(void)showAlert
{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter your name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    
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
    if(buttonIndex){
        [_gameManager setPlayerName:[[alertView textFieldAtIndex:0] text]];
        NSLog(@"%@",[_gameManager getPlayerName]);
        [self fillLabels];
    }
}

-(void)initialize
{
    if(!_gameManager)
        _gameManager = [[GameManager alloc] init];
    
    [self.tableView setBackgroundView:[[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"game_bg"]]];
    _mainCell.backgroundView = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"profile_bg"]];
    _buttonCell.backgroundColor = [UIColor clearColor];
    _namePlayerLabel.font = [UIFont fontWithName:@"Homestead-Inline" size:30];
    _expLabel.font = [UIFont fontWithName:@"Homestead-Inline" size:20];
    _catchedLabel.font = [UIFont fontWithName:@"Homestead-Inline" size:20];
}


@end
