//
//  GroupHuntingVC.h
//  MonsterJack
//
//  Created by stefano on 11/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameManager;

@interface GroupHuntingVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) GameManager *gameManager;


@end
