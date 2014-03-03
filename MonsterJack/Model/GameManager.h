//
//  GameManager.h
//  MonsterJack
//
//  Created by stefano on 04/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MonsterCollection;
@class Monster;

@interface GameManager : NSObject

@property (nonatomic) BOOL playerCreated;

-(void)setPlayerName:(NSString*)aName;
-(NSString*)getPlayerName;

-(NSURL*)getImagePath;
-(void)setImagePath:(NSURL*)path;

-(NSUInteger)getExperience;
-(NSUInteger)getCatchedCount;

- (void)saveImage: (UIImage*)image;
- (UIImage*)loadImage;


-(void)deleteUserFile;
-(void)saveData;
-(void)loadUserData;


-(MonsterCollection*)getMonsterCollection;

- (void)setMonster:(NSUInteger)aMonsterIdentifier catched:(BOOL)catched;
- (UIImage*)getMonsterImage:(NSUInteger)aMonsterIdentifier;
- (Monster*)monsterByIdentifier:(NSUInteger)identifier;


@end
