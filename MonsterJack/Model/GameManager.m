//
//  GameManager.m
//  MonsterJack
//
//  Created by stefano on 04/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "GameManager.h"
#import "MonsterCollection.h"
#import "Player.h"

#define UserFileName @"Player.dat"
#define BufferLength 128

@interface GameManager ()

@property (nonatomic, strong) MonsterCollection *monsterCollection;
@property (nonatomic, strong) Player *player;

@end

@implementation GameManager

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        // create monsterCollection
        _monsterCollection = [[MonsterCollection alloc] init];
        
        // check userfile
        if (![self userFileExists]){
            
            _playerCreated = NO;
            NSLog(@"userFile not found");

        } else {
        
            [self loadUserData];
            
            _playerCreated = YES;
            NSLog(@"userFile found - data loaded");
        
        }
    }
    return self;
}

- (Monster*)monsterByIdentifier:(NSUInteger)identifier
{
    return [_monsterCollection monsterByIdentifier:identifier];
}

- (void)setMonster:(NSUInteger)aMonsterIdentifier catched:(BOOL)catched
{
    [_monsterCollection setMonster:aMonsterIdentifier catched:catched];
}

- (UIImage*)getMonsterImage:(NSUInteger)aMonsterIdentifier{

    return [_monsterCollection getMonsterImage:aMonsterIdentifier];
}

-(NSURL*)getImagePath
{
    return _player.imagePath;
}

-(void)setImagePath:(NSURL*)path{
    
    if (!_player.imagePath) {
        _player.imagePath = [[NSURL alloc] init];
    }
    
    _player.imagePath = path;
}

-(MonsterCollection*)getMonsterCollection
{
    return self.monsterCollection;
}


-(NSUInteger)getExperience
{
    return _monsterCollection.experience;
}

-(NSUInteger)getCatchedCount
{
    return _monsterCollection.catchedCount;
}


-(void)saveData
{
    if (![_player.name length]) {
        return;
        NSLog(@"player name length = 0");
    }
    
    
    NSString *dataFile;
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Identify the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the data file
    dataFile = [docsDir stringByAppendingPathComponent:UserFileName];
    
    FILE *fp = fopen([dataFile UTF8String], "w");

    // Player name
    fputs([_player.name UTF8String], fp);
    fprintf(fp, "\n");
    
    // score
    fprintf(fp, "%d\n",(int) [_monsterCollection experience]);
    
    // imagePath
    NSURL *imagePath = [self getImagePath];
    if (imagePath) {
        NSString *stringPath = [imagePath absoluteString];
        fputs([stringPath UTF8String], fp);
        fprintf(fp, "\n");
    } else {
        fprintf(fp, "null\n");
    }
    NSLog(@"%@",imagePath);
    
    NSArray *catched = [_monsterCollection allMonstersCatched];
    
    for (Monster *monster in catched)
        fprintf(fp, "%d\n",(int)monster.identifier);
    
    fclose(fp);
}

-(void)deleteUserFile
{
    NSString *dataFile;
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Identify the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the data file
    dataFile = [docsDir stringByAppendingPathComponent:UserFileName];
    
    NSFileManager *file = [NSFileManager defaultManager];
    [file removeItemAtPath:dataFile error:nil];
    
}

-(void)setPlayerName:(NSString*)aName
{
    if(!_player)
        _player = [[Player alloc] init];
    
    _player.name = aName;
}

-(NSString*)getPlayerName
{
    return _player.name;
}

-(void)loadUserData
{
    NSString *dataFile;
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Identify the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the data file
    dataFile = [docsDir stringByAppendingPathComponent:UserFileName];
    
    FILE *fp = fopen([dataFile UTF8String], "r");
    char buffer[BufferLength];
    memset(buffer, 0, BufferLength);
    int score = -1;
    
    // read Player name
    fgets(buffer, BufferLength, fp);
    
    // delete \n
    buffer[strlen(buffer)-1] = 0;
    
    // read expScore
    fscanf(fp, "%d\n", &score);
    
    _player = [[Player alloc] initWithName:[NSString stringWithUTF8String:buffer] experience:score imagePath:nil];
    
    // read image path
    fgets(buffer, BufferLength, fp);
    buffer[strlen(buffer)-1] = 0;
    
    if ([[NSString stringWithUTF8String:buffer] isEqualToString:@"null"]) {
        ;
    } else {
        [_player setImagePath:[NSURL URLWithString:[NSString stringWithUTF8String:buffer]]];
    }
    
    while (fgets(buffer, BufferLength, fp)) {
        if(buffer[0]!='\n'){
            int identifier;
            sscanf(buffer, "%d", &identifier);
            [_monsterCollection setMonster:identifier catched:YES];
        }
    }
    
}

- (void)saveImage: (UIImage*)image
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:@"test.png"];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

- (UIImage*)loadImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"test.png"];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

-(BOOL)userFileExists
{
    NSFileManager *fileManager;
    NSString *dataFile;
    NSString *docsDir;
    NSArray *dirPaths;
    
    fileManager = [NSFileManager defaultManager];
    
    // Identify the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the data file
    dataFile = [docsDir stringByAppendingPathComponent:UserFileName];
    
    // Check if the file already exists
    return [fileManager fileExistsAtPath: dataFile];
}

@end
