//
//  VBViewController.m
//  Loca2
//
//  Created by Vitaliy Berg on 5/10/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBViewController.h"
#import <MapKit/MapKit.h>
#import "VBAppDelegate.h"
#import "VBLog.h"

@interface VBViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation VBViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [[VBLog sharedLog] log:[NSString stringWithFormat:@"awakeFromNib"]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [[VBLog sharedLog] log:[NSString stringWithFormat:@"viewDidLoad"]];
    [super viewDidLoad];
    
    [self updateRegionCountLabel];
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(55.767014, 37.588177);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 6000, 6000);
    [self.mapView setRegion:region animated:NO];
    
    [self showRegions];
    
    [self initialLoadLog];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLog:)
                                                 name:VBLogDidLogNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [[VBLog sharedLog] log:[NSString stringWithFormat:@"viewWillAppear"]];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[VBLog sharedLog] log:[NSString stringWithFormat:@"viewWillDisappear"]];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateRegionCountLabel {
    NSInteger regionCount = [[VBAppDelegate sharedDelegate].locationManager.monitoredRegions count];
    self.label.text = [NSString stringWithFormat:@"Regions: %d", regionCount];
}

#pragma mark - Log

- (void)didLog:(NSNotification *)notification {
    [self addTextToLog:notification.userInfo[VBLogItemKey][@"text"]];
}

- (void)initialLoadLog {
    for (NSDictionary *item in [VBLog sharedLog].logs) {
        [self addTextToLog:item[@"text"]];
    }
}

- (void)addTextToLog:(NSString *)text {
    self.textView.text = [self.textView.text stringByAppendingFormat:@"%@\n", text];
}

#pragma mark - Regions on Map

- (void)showRegions {
    [self.mapView removeOverlays:self.mapView.overlays];
    NSSet *regions = [VBAppDelegate sharedDelegate].locationManager.monitoredRegions;
    for (CLRegion *region in regions) {
        [self addRegionToMap:region];
    }
}

- (void)addRegionToMap:(CLRegion *)region {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(region.center.latitude, region.center.longitude);
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:center radius:region.radius];
    [self.mapView addOverlay:circle];
}

#pragma mark - Regions Adding

- (void)addRegions {
    NSURL *regionsURL = [[NSBundle mainBundle] URLForResource:@"Regions.plist" withExtension:@""];
    NSArray *regions = [NSArray arrayWithContentsOfURL:regionsURL];
    for (NSDictionary *region in regions) {
        [self addRegion:region];
    }
}

- (void)addRegion:(NSDictionary *)region {
    [self addRegionWithLatitude:[region[@"latitude"] doubleValue]
                      longitude:[region[@"longitude"] doubleValue]
                         radius:[region[@"radius"] doubleValue]
                     indetifier:region[@"identifier"]];
}

- (void)addRegionWithLatitude:(CLLocationDegrees)latitude
                    longitude:(CLLocationDegrees)longitude
                       radius:(CLLocationDistance)radius
                   indetifier:(NSString *)identifier
{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:center radius:radius identifier:identifier];
    [[VBAppDelegate sharedDelegate].locationManager startMonitoringForRegion:region];
}

#pragma mark - Actions

- (IBAction)addRegionsTouchUpInside:(id)sender {
    [self addRegions];
    
    // Hack, rewrite it!
    [self performSelector:@selector(updateRegionCountLabel) withObject:nil afterDelay:0.3];
    [self performSelector:@selector(showRegions) withObject:nil afterDelay:0.3];
    //[self updateRegionCountLabel];
    //[self showRegions];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    circleView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    circleView.lineWidth = 2;
    return circleView;
}

@end
