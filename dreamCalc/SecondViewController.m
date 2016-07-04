//
//  SecondViewController.m
//  dreamCalc
//
//  Created by Yura Yasinskyy on 27.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()


@property (strong, nonatomic) UIDesignMethods* uiDesignMethods;

@property (strong, nonatomic) NSArray* dataToTransferX;

@property (strong, nonatomic) NSArray* dataToTransferY;

@property NSInteger dataLength;

@property (strong, nonatomic) AVAudioPlayer* audioPlayer2;

@property (strong, nonatomic) PlotView* graphView;

@end


@implementation SecondViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    
    self.uiDesignMethods = [[UIDesignMethods alloc] init];
    //Class with UI methods
    NSLog(@"Second view UI class initialised.");
    
    //Setting blured background image
    UIImage* myBackgroundImage = [UIImage imageNamed:@"galaxy1.png"];
    UIImage *myBackgroundImageBlurred = [self.uiDesignMethods blurWithCoreImage: myBackgroundImage andUIView: self.view];
    self.view.backgroundColor = [UIColor colorWithPatternImage: myBackgroundImageBlurred];
    NSLog(@"Second View Blured Background set.");
    
    //Sets white statusbar text color
    [self preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
    NSLog(@"Second view statusbar style set.");
    
    //Preparing for plots
    self.inputLabel.text = self.labelTextFromFirstView;
    [self calculatingDataForPlots: self.inputLabel.text];
    
    self.graphView = [[PlotView alloc] initWithFrame:CGRectMake(0, 0, 900, 900)];
    self.graphView.transferedDataX = self.dataToTransferX;
    self.graphView.transferedDataY = self.dataToTransferY;
    self.graphView.countOfElements = self.dataLength;
    [self.plotScrollView addSubview: self.graphView];
    [self.graphView setBackgroundColor: [UIColor clearColor]];
    NSLog(@"Graph subView to scrollView added.");
    
    self.plotScrollView.contentSize = CGSizeMake(defaultGraphWidth, defaultGraphHeight);
    [self.plotScrollView setContentOffset:CGPointMake(285, 215)];
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
    [self.graphView addGestureRecognizer:twoFingerPinch];
    
    
    NSMutableArray* forParallax = [[NSMutableArray alloc] init];
    [forParallax addObject: self.graphView];
    [self.uiDesignMethods parallaxImplementor:[forParallax copy]];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}


-(void) calculatingDataForPlots: (NSString*) functionInString {
    
    
    CalculatorModel* calcModel = [[CalculatorModel alloc] init];
    NSString* functionToTabulate = @"";
    NSString* inputFunction = functionInString;
    inputFunction = self.inputLabel.text;
    
    //Tabulation params
    NSInteger a = -15;
    NSInteger b = 15;
    CGFloat step = 0.5;
    
    NSString* stringAfterRegex;
    
        stringAfterRegex = [calcModel regexSyntaxCheker: inputFunction];
        
        if ([stringAfterRegex hasPrefix:@"A"] || [stringAfterRegex hasPrefix:@"N"] || stringAfterRegex.length < 3) {
            
            self.inputLabel.text = @"Are you sure everything is ok?";
            
        }
        else {
            
            NSString* parsedString = [calcModel parseUserInputFromLabel: stringAfterRegex];
            NSLog(@"%@", parsedString);
            
            for (NSInteger i = 2; i < parsedString.length; i++) {
                
                functionToTabulate = [NSString stringWithFormat:@"%@%c", functionToTabulate, [parsedString characterAtIndex:i]];
            }
            
            [calcModel functionTabulator:functionToTabulate andRange:a andEnd:b andStep:step];
            
            self.dataToTransferX = calcModel.tabulatedXdata;
            self.dataToTransferY = calcModel.tabulatedYdata;
            
            self.dataLength = self.dataToTransferX.count;
            
        }
}


- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer {
    
    //It's possible to implement any int/float value in context of what scale you want to zoom in or out
    CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
    
    self.graphView.transform = transform;
}



- (UIStatusBarStyle) preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}


- (IBAction)styleChanger:(id)sender {
    
    
    // Construct URL to sound file
    NSString *pathToAudioFile = [NSString stringWithFormat:@"%@/A Day in the Life.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *audioFileURL = [NSURL fileURLWithPath:pathToAudioFile];
    
    // Create audio player object and initialize with URL to sound
    self.audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:nil];
    [self.audioPlayer2 play];
    
    
}

- (IBAction)buttonFirstViewTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1004);
    
    [self.audioPlayer2 stop];
}

@end
