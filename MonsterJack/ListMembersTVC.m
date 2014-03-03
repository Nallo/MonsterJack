//
//  ListMembersTVC.m
//  MonsterJack
//
//  Created by stefano on 12/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "ListMembersTVC.h"
#import "GroupHuntingActionVC.h"

@interface ListMembersTVC ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) NSMutableArray *membersArray;
@property (nonatomic, strong) NSMutableArray *monstersAvailable;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;

@property (atomic) BOOL requestSent;

@property (strong, nonatomic) IBOutlet UIButton *startCaptureButton;
@property (strong, nonatomic) UIImageView *profilePic;

@end

#define baseUrl @"http://www.nallo.altervista.org/monsterjack/query.php?"

@implementation ListMembersTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundView:[[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"game_bg"]]];

    // location manager init
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
    
    // location init
    self.location = [[CLLocation alloc] init];
    
    // set flags
    self.requestSent = NO;
    
    NSLog(@"list did load");
    
    [self initArrays];
    [self animateOval];
    
    [[self startCaptureButton] setHidden:YES];
    
    
    _profilePic = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)-37.5, (self.view.bounds.size.height/2)-45, 75, 75)];
    _profilePic.image = [_gameManager loadImage];
    _profilePic.layer.cornerRadius = 37;
    _profilePic.layer.masksToBounds = YES;
    [self.view addSubview:_profilePic];


}

-(void)initArrays{
    
    if (!_monstersAvailable) {
        _monstersAvailable = [[NSMutableArray alloc] init];
    }
    
    if (!_membersArray) {
        _membersArray = [[NSMutableArray alloc] init];
    }
    
}

#pragma mark - animation oval view

#define kGrowFactor 3

-(void)animateOval{
    
    if (![self growAnimation]) {
        
        _growAnimation = [[OvalView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)-25, (self.view.bounds.size.height/2)-35, 50, 50)];
        [self.view addSubview:_growAnimation];
    }

    CGAffineTransform transform = CGAffineTransformScale(self.growAnimation.transform, kGrowFactor, kGrowFactor);
    
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{self.growAnimation.transform = transform;}
                     completion:nil];

}

#pragma mark - refresh

- (IBAction)refresh:(id)sender {
    
    [self.refreshControl beginRefreshing];
    
    [[self growAnimation] setHidden:NO];
    [[self profilePic] setHidden:NO];
    [[self startCaptureButton] setHidden:YES];
    
    [_monstersAvailable removeAllObjects];
    [_membersArray removeAllObjects];
    [self.tableView reloadData];
    
    [self performSelectorInBackground:@selector(getMembersFromNetwork) withObject:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
    
}

#pragma mark - network operations

-(void)getMembersFromNetwork
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@",baseUrl];
    
    [urlString appendString:[NSString stringWithFormat:@"name=%@",[self playerName]]];
    [urlString appendString:[NSString stringWithFormat:@"&lat1=%.3f",self.location.coordinate.latitude]];
    [urlString appendString:[NSString stringWithFormat:@"&lon1=%.3f",self.location.coordinate.longitude]];
    [urlString appendString:[NSString stringWithFormat:@"&exp=%d",(int)[self expPoints]]];
    [urlString appendString:[NSString stringWithFormat:@"&members=%d",(int)[self numberOfMembers]]];
    
    _url = [[NSURL alloc] initWithString:urlString];
    NSLog(@"request sent");
    NSLog(@"%@", [self playerName]);
    NSData *data = [NSData dataWithContentsOfURL:_url];
    
    [self fetchedData:data];
    
}

- (void)fetchedData:(NSData *)responseData {
    
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSString *status = [json objectForKey:@"status"];
    
    if ([status isEqualToString:@"ok"]) {
        
        NSArray *monsters = [json objectForKey:@"monsters"];
        NSArray *players = [json objectForKey:@"hunters"];
        
        [_monstersAvailable removeAllObjects];
        [_membersArray removeAllObjects];
        
        [_membersArray addObject:[NSString stringWithFormat:@"You are close to:"]];
        [_membersArray addObjectsFromArray:players];
        [_monstersAvailable addObjectsFromArray:monsters];
        
        NSLog(@"%@", players);
        [self.tableView reloadData];

        [[self startCaptureButton] setHidden:NO];
        
    } else if ([status isEqualToString:@"error in DB"]){
        NSLog(@"There's no one around you.");
        [_membersArray removeAllObjects];
        [_membersArray addObject:[NSString stringWithFormat:@"There's no one around you."]];
        [self.tableView reloadData];
    }
    [[self growAnimation] setHidden:YES];
    [[self profilePic] setHidden:YES];
}



#pragma mark - location manager delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(!self.requestSent){
        self.requestSent = YES;
        self.location = locations.lastObject;
        
        [self performSelectorInBackground:@selector(getMembersFromNetwork) withObject:nil];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_membersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // draw the header
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = @"Hunters";
    tableView.tableHeaderView = headerLabel;
    
    
    
    static NSString *CellIdentifier = @"memberCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    if (_membersArray) {
        cell.textLabel.font = [UIFont fontWithName:@"Homestead-Inline" size:15];
        cell.textLabel.text = [_membersArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

#pragma mark - navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"startCap"]) {
        if ([segue.destinationViewController isKindOfClass:[GroupHuntingActionVC class]]) {
            GroupHuntingActionVC *groupHunting = (GroupHuntingActionVC*) segue.destinationViewController;
            groupHunting.gameManager = self.gameManager;
        }
    }
    

}

@end
