//
//  MonsterCollection.m
//  MonsterJack
//
//  Created by stefano on 29/11/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "MonsterCollection.h"

#define NumberOfMonsters 4

@interface MonsterCollection ()

@property (nonatomic, strong) NSMutableArray *monstersArray;
@property (nonatomic,readonly) NSUInteger catchedMonsters;

@end

@implementation MonsterCollection

@synthesize monstersArray = _monstersArray;

#define MonsterFileName @"/Users/stefano/Developer/MonsterJack/MonsterJack/Model/monsters.dat"
#define BufferLength 128
#define ExpFactor 1000

# pragma mark - init



- (id)init
{
	if (self = [super init])
    {
        _monstersArray = [[NSMutableArray alloc] init];
        [self fillMonsterArray];
	}
	return self;
}

-(void)fillMonsterArray
{
    NSString *stringURL = @"http://www.nallo.altervista.org/monsterjack/monsters.dat";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    NSString *contentOfFile = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSArray *rows = [[NSArray alloc] initWithArray:[contentOfFile componentsSeparatedByString:@"\n"]];
    
    for (NSString *row in rows) {
        if ([row length]) {
            NSArray *fields = [[NSArray alloc] initWithArray:[row componentsSeparatedByString:@" "]];
            Monster *monster = [[Monster alloc] initWithName:[fields objectAtIndex:0]
                                                  identifier:[[fields objectAtIndex:1] integerValue]
                                                    expPoint:[[fields objectAtIndex:5] integerValue]
                                                   colorName:[fields objectAtIndex:6]
                                                groupMembers:[[fields objectAtIndex:7] integerValue]];
            [self addMonster:monster];
            NSLog(@"%@",row);
        }
    }
}

#pragma mark - functions

- (UIImage*)getMonsterImage:(NSUInteger)aMonsterIdentifier
{
    Monster *monster = [_monstersArray objectAtIndex:aMonsterIdentifier];
    return monster.image;
}

-(NSUInteger)experience
{
    return ExpFactor*[self catchedCount];
}

- (NSUInteger)count
{
    return [_monstersArray count];
}

- (NSUInteger)catchedCount
{
    NSUInteger cathced = 0;
    
    for (Monster *monster in _monstersArray)
        if ([monster isCatched])
            cathced++;

    return cathced;
}

- (NSArray*)allMonsters{
    return [NSArray arrayWithArray:_monstersArray];
}

- (NSArray*)allMonstersCatched
{
    NSMutableArray *catched = [[NSMutableArray alloc] init];
    
    for (Monster *monster in _monstersArray)
        if([monster isCatched])
            [catched addObject:monster];
    
    return catched;
}

- (Monster*)monsterByIdentifier:(NSUInteger)identifier
{
    if (identifier < [_monstersArray count]) {
        return [_monstersArray objectAtIndex:identifier];
    } else {
        return nil;
    }

}

- (void)addMonster:(Monster *)aMonster
{
    [_monstersArray insertObject:aMonster atIndex:[aMonster identifier]];
}

- (void)setMonster:(NSUInteger)aMonsterIdentifier catched:(BOOL)catched
{
    Monster *monster = [_monstersArray objectAtIndex:aMonsterIdentifier];
    monster.catched = catched;
}


@end
