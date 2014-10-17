//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "DivvyBikeStation.h"
#import "MapViewController.h"

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *divvyStationData;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.divvyStationData = [[NSMutableArray alloc] init];
    [self fetchJSONData];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.divvyStationData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    DivvyBikeStation *station = [self.divvyStationData objectAtIndex:indexPath.row];
    cell.textLabel.text = station.stationName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ bikes available",station.availableDocks];
    return cell;
}

#pragma mark - Get & Set Divvy Station Info

-(void) fetchJSONData
{
    NSURL *url = [NSURL URLWithString:@"http://www.divvybikes.com/stations/json/"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *rawData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSArray *divvyStationLibrary = [rawData objectForKey:@"stationBeanList"];

        for (NSDictionary *divvyStation in divvyStationLibrary) {
            DivvyBikeStation *newStation = [DivvyBikeStation createStation:divvyStation];
            [self.divvyStationData addObject:newStation];
            [self.tableView reloadData];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    MapViewController *mapViewController = [segue destinationViewController];
    mapViewController.station = [self.divvyStationData objectAtIndex:[self.tableView indexPathForSelectedRow].row];
}

@end
