//
//  ViewController.m
//  MapCircleTest
//
//  Created by ryu-ushin on 2015/01/22.
//  Copyright (c) 2015年 rain. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation ViewController{
    MKPointAnnotation *_annotation;
    
    NSArray *_pickerData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //create annotation
    _annotation = [[MKPointAnnotation alloc] init];
    
    _annotation.coordinate = CLLocationCoordinate2DMake(35.463202,139.625107);
    
    [self.mapView addAnnotation:_annotation];
    
    
    //create picker data
    _pickerData = @[@100, @200, @300, @400, @500, @600, @700, @800, @900, @1000];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //set region
    [self mapView:self.mapView zoomToCoordinate:_annotation.coordinate radius:100];

}

#pragma mark - convenient method
-(void)mapView:(MKMapView *)mapView zoomToCoordinate:(CLLocationCoordinate2D)coordinate radius:(CGFloat)radius{
    
    NSLog(@"the radius :%f", radius);
    
    //clean overlays
    if ([[mapView overlays] count]) {
        [mapView removeOverlays:[mapView overlays]];
    }
    
    
    //set region
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:MKCoordinateRegionMakeWithDistance(coordinate, 2*radius, 2*radius)];
    
    [mapView setRegion:adjustedRegion animated:YES];
    
    
    //create circle
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:radius];
    
    [mapView addOverlay:circle];

}

#pragma mark - mapView delegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
    
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
        
        renderer.strokeColor = [UIColor redColor];

        renderer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
        
        renderer.lineWidth = 3;
        
        return renderer;
    }
    
    return nil;
}


#pragma mark - picker delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_pickerData count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *string = [NSString stringWithFormat:@"%@ m", [_pickerData[row] stringValue]];
    
    return string;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    //set region
    [self mapView:self.mapView zoomToCoordinate:_annotation.coordinate radius:[_pickerData[row] floatValue]];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
