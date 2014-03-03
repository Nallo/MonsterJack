//
//  MonsterCollection.h
//  MonsterJack
//
//  Created by stefano on 29/11/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Monster.h"

@interface MonsterCollection : NSObject



- (Monster*)monsterByIdentifier:(NSUInteger)identifier;
- (UIImage*)getMonsterImage:(NSUInteger)aMonsterIdentifier;

- (NSUInteger)count;
- (NSUInteger)catchedCount;
- (NSUInteger)experience;

- (NSArray*)allMonsters;
- (NSArray*)allMonstersCatched;

- (void)addMonster:(Monster *)aMonster;
- (void)setMonster:(NSUInteger)aMonsterIdentifier catched:(BOOL)catched;

@end
