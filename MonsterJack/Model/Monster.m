//
//  Monster.m
//  MonsterJack
//
//  Created by stefano on 29/11/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "Monster.h"

#define ImageDirectory @"/Users/stefano/Developer/MonsterJack/monsters_images/"

@implementation Monster

- (id)init
{
    return [self initWithName:@"" identifier:0 expPoint:0 colorName:nil groupMembers:0];
}

- (id)initWithName:(NSString *)aString identifier:(NSUInteger)anIdentifier expPoint:(NSUInteger)exp colorName:(NSString*)aColor groupMembers:(NSUInteger)members{
    self = [super init];
    
    if (self) {
        _name = [aString copy];
        _identifier = anIdentifier;
        _catched = NO;
        _expPoint = exp;
        
        _image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.nallo.altervista.org/monsterjack/images/m%d.png",(int)anIdentifier]]]];
        
        _colorName = [NSString stringWithString:aColor];
        _groupMembers = members;
    
        
    }
    return  self;
}

@end
