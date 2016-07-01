//
//  SecondViewController.m
//  dreamCalc
//
//  Created by Yura Yasinskyy on 27.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

@synthesize myUI ,plotScrollView, graphView, inputLabel, wallpaperButton, buttonFirstView, dreamLabel, dataToTransferX, dataToTransferY, dataLength, labelTextTransfer;

- (void) viewDidLoad {
    [super viewDidLoad];

    
    myUI = [[UIDesign alloc] init];
    //Class with UI methods
    myUI = [[UIDesign alloc] init];
    NSLog(@"Second view UI class initialised.");
    
    //Setting blured background image
    UIImage* myBackgroundImage = [UIImage imageNamed:@"nature1.png"];
    NSLog(@"Second view background picture found.");
    
    UIImage *myBackgroundImageBlurred = [myUI blurWithCoreImage: myBackgroundImage andUIView: self.view];
    NSLog(@"Blurring done.");
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: myBackgroundImageBlurred];
    NSLog(@"Background set.\n\n");
    
    //Sets white statusbar text color
    [self preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
    NSLog(@"Second view statusbar style set.");
    
    
    
    //Preparing for plots
    graphView = [[PlotView alloc] initWithFrame:CGRectMake(0, 0, 900, 900)];
    
    
    graphView.transferedDataX = dataToTransferX;
    graphView.transferedDataY = dataToTransferY;
    graphView.n = dataLength;
    inputLabel.text = labelTextTransfer;
    
    
    
    [plotScrollView addSubview: graphView];
    //[graphView setBackgroundColor: plotScrollView.backgroundColor];
    [graphView setBackgroundColor: [UIColor clearColor]];
    NSLog(@"Graph subview to scrollView added.");
    
    plotScrollView.contentSize = CGSizeMake(kDefaultGraphWidth, kGraphHeight);
    [plotScrollView setContentOffset:CGPointMake(285, 215)];


    
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(twoFingerPinch:)];
    
    [graphView addGestureRecognizer:twoFingerPinch];
    
    
    
    
    NSMutableArray* forParallax = [[NSMutableArray alloc] init];
    [forParallax addObject:graphView];
    
    [myUI parallaxImplementor:forParallax];
    
    
    
}



- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    NSLog(@"Pinch scale: %f", recognizer.scale);
    //AudioServicesPlaySystemSound(1057);
    CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
    // you can implement any int/float value in context of what scale you want to zoom in or out
    graphView.transform = transform;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    

    
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}


- (IBAction)styleChanger:(id)sender {
}

- (IBAction)buttonFirstViewTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1004);
    
    
}
@end
