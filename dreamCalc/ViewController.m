//
//  ViewController.m
//  dreamCalc
//
//  Created by Yura Yasinskyy on 15.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()


//internal properties
@property (nonatomic) CGFloat radius;

@property (nonatomic) CGFloat screenWidth;

@property (nonatomic) CGFloat screenHeight;

@property (nonatomic) NSInteger buttonsCenterOffset;

@property (nonatomic) NSInteger countOfLeftBrackets;

@property (nonatomic) NSInteger countOfRightBrackets;

@property BOOL isYPressed;

@property (strong, nonatomic) UIDesignMethods* uiDesignMethods;

@property (strong, nonatomic) NSMutableArray* upperScientificFunctions;

@property BOOL styleChangeButtonPressed;


@end



@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(tapRecognizer:)];
    [self.inputLabel addGestureRecognizer: tapper];
    
    self.buttonSin.hidden = YES;
    self.buttonCos.hidden = YES;
    self.buttonTan.hidden = YES;
    self.buttonCtg.hidden = YES;
    self.buttonPower.hidden = YES;
    self.buttonSecondView.hidden = YES;
    self.buttonX.hidden = YES;
    self.buttonY.hidden = YES;
    self.buttonTabulate.hidden = YES;
    self.algorithmChanger.hidden = NO;
    self.goToLandscapeButton.hidden = YES;
    
    //Class with UI methods
    self.uiDesignMethods = [[UIDesignMethods alloc] init];
    NSLog(@"UI class initialised.");
    
    //Sets white statusbar text color
    [self preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
    NSLog(@"Statusbar style set.");
    
    //Getting size of the screen
    self.screenBound = [[UIScreen mainScreen] bounds];
    self.screenWidth = CGRectGetWidth(self.screenBound);
    self.screenHeight = CGRectGetHeight(self.screenBound);
    
    //Making arrays with views and setting parallax effect
    NSMutableArray* innerCircleButtons = [[NSMutableArray alloc] init];
    [innerCircleButtons addObject: self.buttonPlus];
    [innerCircleButtons addObject: self.buttonMinus];
    [innerCircleButtons addObject: self.buttonMultiply];
    [innerCircleButtons addObject: self.buttonDivide];
    [innerCircleButtons addObject: self.buttonComma];
    [innerCircleButtons addObject: self.buttonErase];
    [innerCircleButtons addObject: self.buttonBracketRight];
    [innerCircleButtons addObject: self.buttonBracketLeft];
    
    NSMutableArray* outerCircleButtons = [[NSMutableArray alloc] init];
    [outerCircleButtons addObject: self.buttonTwo];
    [outerCircleButtons addObject: self.buttonThree];
    [outerCircleButtons addObject: self.buttonFour];
    [outerCircleButtons addObject: self.buttonFive];
    [outerCircleButtons addObject: self.buttonSix];
    [outerCircleButtons addObject: self.buttonSeven];
    [outerCircleButtons addObject: self.buttonEight];
    [outerCircleButtons addObject: self.buttonNine];
    [outerCircleButtons addObject: self.buttonZero];
    [outerCircleButtons addObject: self.buttonOne];
    
    self.upperScientificFunctions = [[NSMutableArray alloc] init];
    [self.upperScientificFunctions addObject: self.buttonSin];
    [self.upperScientificFunctions addObject: self.buttonCos];
    [self.upperScientificFunctions addObject: self.buttonTan];
    [self.upperScientificFunctions addObject: self.buttonCtg];
    [self.upperScientificFunctions addObject: self.buttonPower];
    [self.upperScientificFunctions addObject: self.buttonY];
    [self.upperScientificFunctions addObject: self.buttonX];
    [self.upperScientificFunctions addObject: self.buttonSecondView];
    
    NSMutableArray* otherViews = [[NSMutableArray alloc] init]; //labels etc.
    [otherViews addObject: self.dreamLabel];
    [otherViews addObject: self.inputLabel];
    [otherViews addObject: self.algorithmChanger];
    [otherViews addObject: self.styleChanger];
    [otherViews addObject: self.buttonEquals];
    [otherViews addObject: self.scientificSwitch];
    [otherViews addObject: self.turboModeLabel];

    [self.uiDesignMethods parallaxImplementor: [innerCircleButtons copy]];
    [self.uiDesignMethods parallaxImplementor: [outerCircleButtons copy]];
    [self.uiDesignMethods parallaxImplementor: [self.upperScientificFunctions copy]];
    [self.uiDesignMethods parallaxImplementor: [otherViews copy]];
    NSLog(@"Parallax effect set.");
    
    //Setting blured background image
    UIImage* myBackgroundImage = [UIImage imageNamed:@"nature1.png"];
    UIImage *myBackgroundImageBlurred = [self.uiDesignMethods blurWithCoreImage: myBackgroundImage andUIView: self.view];
    self.view.backgroundColor = [UIColor colorWithPatternImage: myBackgroundImageBlurred];
    NSLog(@"BluredBackground set.\n\n");
    
    self.buttonsCenterOffset = 25; //to move button a bit down for a beeter reachebility
    
    //Positioning equals button in the center of the view
    self.buttonEquals.center = CGPointMake(self.screenWidth/2, self.screenHeight/2+self.buttonsCenterOffset); //centering '=' button
    
    //Positioning inner circle buttons
    self.radius = 64.0;
    self.buttonPlus.center = CGPointMake(self.screenWidth/2, self.screenHeight/2 - self.radius+self.buttonsCenterOffset); //centering '+' button relatively '='
    [self.uiDesignMethods positioningObjectsInCircle:innerCircleButtons andPreferedRadius:self.radius andScreenBounds:&(_screenBound) andVerticalOffset:self.buttonsCenterOffset];
    NSLog(@"Inner circle of buttons formed.\n\n");
    
    //Positioning outer circle buttons
    self.radius = 125.0;
    self.buttonTwo.center = CGPointMake(self.screenWidth/2, self.screenHeight/2 - self.radius+self.buttonsCenterOffset); //centering '2' button relatively '='
    [self.uiDesignMethods positioningObjectsInCircle:outerCircleButtons andPreferedRadius:self.radius andScreenBounds:&(_screenBound) andVerticalOffset:self.buttonsCenterOffset];
    NSLog(@"Outer circle of buttons formed.\n\n");
    
    //Positioning scientific buttons
    NSInteger scientificButtonsHorizontalOffset = 50;
    NSInteger scientificButtonsVerticalOffset = 81;
    self.buttonPower.center = CGPointMake(self.buttonOne.center.x-1, self.buttonOne.center.y-scientificButtonsVerticalOffset);
    self.buttonY.center = CGPointMake(self.buttonPower.center.x+scientificButtonsHorizontalOffset, self.buttonPower.center.y);
    self.buttonX.center = CGPointMake(self.buttonY.center.x+scientificButtonsHorizontalOffset, self.buttonY.center.y);
    self.buttonSecondView.center = CGPointMake(self.buttonX.center.x+scientificButtonsHorizontalOffset, self.buttonX.center.y);
    self.buttonSin.center = CGPointMake(self.buttonEight.center.x-1, self.buttonEight.center.y+scientificButtonsVerticalOffset);
    self.buttonCos.center = CGPointMake(self.buttonSin.center.x+scientificButtonsHorizontalOffset, self.buttonSin.center.y);
    self.buttonTan.center = CGPointMake(self.buttonCos.center.x+scientificButtonsHorizontalOffset, self.buttonCos.center.y);
    self.buttonCtg.center = CGPointMake(self.buttonTan.center.x+scientificButtonsHorizontalOffset, self.buttonTan.center.y);
    
    //Initializing some values
    self.countOfRightBrackets = 0;
    self.countOfLeftBrackets = 0;
    self.inputLabel.text = @"0";
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tapRecognizer:(UIGestureRecognizer *) sender {
        
    if ([self.inputLabel.text isEqualToString: @"0"] || self.inputLabel.text.length == 1 || [self.inputLabel.text containsString:@"y="] || [self.inputLabel.text containsString:@"sin"] || [self.inputLabel.text containsString:@"cos"] || [self.inputLabel.text containsString:@"tan"] || [self.inputLabel.text containsString:@"ctg"] || [self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text=@"0";
        self.countOfLeftBrackets = 0;
        self.countOfRightBrackets = 0;
        self.isYPressed = NO;
        
    }
    else {
        
        
        NSString *tempSubString = [self.inputLabel.text substringToIndex:[self.inputLabel.text length]-1];
        self.inputLabel.text = tempSubString;
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

- (IBAction)buttonEqualTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1033);
    
    if (self.isYPressed) {
        
        self.inputLabel.text = @"Are you sure everything is ok?";
    }
    else {
    
        CalculatorModel* calcModel = [[CalculatorModel alloc] init];
        NSString* stringAfterRegex;
    
        if (self.countOfLeftBrackets != self.countOfRightBrackets) {
        
            self.inputLabel.text = @"Not enough brackets :(";
            self.countOfLeftBrackets = self.countOfRightBrackets = 0;
        }
        else {
            
            stringAfterRegex = [calcModel regexSyntaxCheker: self.inputLabel.text];
            if ([stringAfterRegex hasPrefix:@"A"]) {
        
                self.inputLabel.text = @"Are you sure everything is ok?";
            }
            else {
        
                NSString* parsedString = [calcModel parseUserInputFromLabel: stringAfterRegex];
        
                if (self.algorithmChanger.selectedSegmentIndex == 0) {
            
                    NSLog(@"RPN ALGORITHM SELECTED");
            
                    CGFloat result;
                    result = [calcModel calculatingResultFromRPN:[calcModel reversePolishNotation: [calcModel prepareToRPN: parsedString]]];
                    
                    self.inputLabel.text = [NSString stringWithFormat:@"%g", result];
                
                }
                else if (self.algorithmChanger.selectedSegmentIndex == 1) {
            
                    NSLog(@"NSEXPRESSION ALGORITHM SELECTED");
                    
                    CGFloat result = [calcModel resultWithNSExpression:parsedString];
                
                    self.inputLabel.text = [NSString stringWithFormat:@"%g", result];
                
                }
            }
        }
    }
    
}

- (IBAction)buttonOneTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1201);
    
        
        if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
            
            self.inputLabel.text = @"1";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
                
                self.inputLabel.text = @"1";
            }
            else {
                
                self.inputLabel.text = [NSString stringWithFormat:@"%@1", self.inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonTwoTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1202);
    
        
        if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
            
            self.inputLabel.text = @"2";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
                
                self.inputLabel.text = @"2";
            }
            else {
                
                self.inputLabel.text = [NSString stringWithFormat:@"%@2", self.inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonThreeTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1203);
    
        
        if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
            
            self.inputLabel.text = @"3";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
                
                self.inputLabel.text = @"3";
            }
            else {
                
                self.inputLabel.text = [NSString stringWithFormat:@"%@3", self.inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonFourTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1204);
    

        
        if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
            
            self.inputLabel.text = @"4";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
                
                self.inputLabel.text = @"4";
            }
            else {
                
                self.inputLabel.text = [NSString stringWithFormat:@"%@4", self.inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonFiveTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1205);
    
        
        if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
            
            self.inputLabel.text = @"5";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
                
                self.inputLabel.text = @"5";
            }
            else {
                
                self.inputLabel.text = [NSString stringWithFormat:@"%@5", self.inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonSixTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1206);
    
    
        if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
            
            self.inputLabel.text = @"6";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
                
                self.inputLabel.text = @"6";
            }
            else {
                
                self.inputLabel.text = [NSString stringWithFormat:@"%@6", self.inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonSevenTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1207);
    
    
        if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
            
            self.inputLabel.text = @"7";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
                
                self.inputLabel.text = @"7";
            }
            else {
                
                self.inputLabel.text = [NSString stringWithFormat:@"%@7", self.inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonEightTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1208);
    
    
        if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
            
            self.inputLabel.text = @"8";
        }
        else {
            if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
                
                self.inputLabel.text = @"8";
            }
            else {
                
                self.inputLabel.text = [NSString stringWithFormat:@"%@8", self.inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonNineTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1209);
    
        
        if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
            
            self.inputLabel.text = @"9";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
                
                self.inputLabel.text = @"9";
            }
            else {
                
                self.inputLabel.text = [NSString stringWithFormat:@"%@9", self.inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonZeroTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1200);
    

        
        if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
            
            self.inputLabel.text = @"0";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
                
                self.inputLabel.text = @"0";
            }
            else {
                
                self.inputLabel.text = [NSString stringWithFormat:@"%@0", self.inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonPlusTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
            
            self.inputLabel.text = @"0+";
        }
        else {
            
            self.inputLabel.text = [NSString stringWithFormat:@"%@+", self.inputLabel.text];
        }
    }
    
}

- (IBAction)buttonMinusTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
            
            self.inputLabel.text = @"0-";
        }
        else {
            
            self.inputLabel.text = [NSString stringWithFormat:@"%@-", self.inputLabel.text];
        }
    }
    
}

- (IBAction)buttonMultiplyTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
            
            self.inputLabel.text = @"0*";
        }
        else {
            
            self.inputLabel.text = [NSString stringWithFormat:@"%@*", self.inputLabel.text];
        }
    }
    
}

- (IBAction)buttonDivideTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
            
            self.inputLabel.text = @"0/";
        }
        else {
            
            self.inputLabel.text = [NSString stringWithFormat:@"%@/", self.inputLabel.text];
        }
    }
    
}

- (IBAction)buttonCommaTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @"0";
    }
    else {
        
        self.inputLabel.text = [NSString stringWithFormat:@"%@.", self.inputLabel.text];
    }
    
}

- (IBAction)buttonClearTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    self.inputLabel.text=@"0";
    self.countOfLeftBrackets = 0;
    self.countOfRightBrackets = 0;
    self.isYPressed = NO;
    
}

- (IBAction)buttonRightBracketTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @")";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
            
            self.inputLabel.text = @"0";
        }
        else {
            
            self.inputLabel.text = [NSString stringWithFormat:@"%@)", self.inputLabel.text];
        }
    }
    
    self.countOfRightBrackets++;
    
}

- (IBAction)buttonLeftBracketTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @"(";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
            
            self.inputLabel.text = @"(";
        }
        else {
            
            self.inputLabel.text = [NSString stringWithFormat:@"%@(", self.inputLabel.text];
        }
    }
    
    self.countOfLeftBrackets++;
    
}

- (IBAction)buttonSinTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
            
            
            self.inputLabel.text = @"sin(";
        }
        else {
            
            self.inputLabel.text = [NSString stringWithFormat:@"%@sin(", self.inputLabel.text];
        }
        
        self.countOfLeftBrackets++;
    }
    
}

- (IBAction)buttonCosTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
            
            
            self.inputLabel.text = @"cos(";
        }
        else {
            
            self.inputLabel.text = [NSString stringWithFormat:@"%@cos(", self.inputLabel.text];
        }
        
        self.countOfLeftBrackets++;
    }
    
}

- (IBAction)buttonTanTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
            
            
            self.inputLabel.text = @"tan(";
        }
        else {
            
            self.inputLabel.text = [NSString stringWithFormat:@"%@tan(", self.inputLabel.text];
        }
        
        self.countOfLeftBrackets++;
    }
    
}

- (IBAction)buttonCtgTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
            
            
            self.inputLabel.text = @"ctg(";
        }
        else {
            
            self.inputLabel.text = [NSString stringWithFormat:@"%@ctg(", self.inputLabel.text];
        }
        
        self.countOfLeftBrackets++;
    }
    
}

- (IBAction)buttonPowerTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
            
            self.inputLabel.text = @"0^";
        }
        else {
            
            self.inputLabel.text = [NSString stringWithFormat:@"%@^", self.inputLabel.text];
        }
    }
}

- (IBAction)buttonXTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([self.inputLabel.text hasPrefix:@"N"] || [self.inputLabel.text hasPrefix:@"A"]) {
        
        self.inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", self.inputLabel.text] isEqualToString:@"0"]) {
            
            self.inputLabel.text = @"0";
        }
        else {
            
            self.inputLabel.text = [NSString stringWithFormat:@"%@x", self.inputLabel.text];
        }
    }
    
}

- (IBAction)buttonYTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    self.inputLabel.text = @"y=";
    
    self.isYPressed = YES;
    
}


- (IBAction)scientificFunctionsEnabler:(id)sender {
    
    AudioServicesPlaySystemSound(1004);
    
    
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.20;
    transition.speed = 0.50;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.delegate = self;
    
    if ([self.scientificSwitch isOn]) {
        
        for (NSInteger i = 0; i < self.upperScientificFunctions.count; i++) {
            
            UIView* viewElement = [self.upperScientificFunctions objectAtIndex: i];
            [viewElement.layer addAnimation:transition forKey:nil];
            
            
        }
        
        self.buttonSin.hidden = NO;
        self.buttonCos.hidden = NO;
        self.buttonTan.hidden = NO;
        self.buttonCtg.hidden = NO;
        self.buttonPower.hidden = NO;
        self.buttonSecondView.hidden = NO;
        self.buttonX.hidden = NO;
        self.buttonY.hidden = NO;
        
    }
    else {
        
        for (NSInteger i = 0; i < self.upperScientificFunctions.count; i++) {
            
            UIView* viewElement = [self.upperScientificFunctions objectAtIndex: i];
            [viewElement.layer addAnimation:transition forKey:nil];
        }
        
        self.buttonSin.hidden = YES;
        self.buttonCos.hidden = YES;
        self.buttonTan.hidden = YES;
        self.buttonCtg.hidden = YES;
        self.buttonPower.hidden = YES;
        self.buttonSecondView.hidden = YES;
        self.buttonX.hidden = YES;
        self.buttonY.hidden = YES;
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if (self.countOfLeftBrackets != self.countOfRightBrackets) {
        
        self.countOfLeftBrackets = self.countOfRightBrackets = 0;
        
        if([segue.identifier isEqualToString:@"goToPlotViewSegue"]){
            SecondViewController *seconViewController = (SecondViewController *)segue.destinationViewController;
            
            seconViewController.labelTextFromFirstView = @"Are you sure everything is ok?";
            
        }
        
    }
    else {
    
        if([segue.identifier isEqualToString:@"goToPlotViewSegue"]){
            SecondViewController *seconViewController = (SecondViewController *)segue.destinationViewController;
        
            seconViewController.labelTextFromFirstView = self.inputLabel.text;
    
        }
    }
    
}

- (IBAction)showSecondView:(id)sender {
    
    
    NSLog(@"Switched to second view.");
    AudioServicesPlaySystemSound(1004);
    
}



- (IBAction)tabulateButtonTouch:(id)sender {
    
    
    CalculatorModel* calcModel = [[CalculatorModel alloc] init];
    
    self.transferingDataX = [[NSMutableArray alloc] init];
    self.transferingDataY = [[NSMutableArray alloc] init];
    
    
    NSString *functionToTabulate = @"";
    
    for (NSInteger i = 2; i < self.inputLabel.text.length; i++) {
        
        functionToTabulate = [NSString stringWithFormat:@"%@%c", functionToTabulate, [self.inputLabel.text characterAtIndex:i]];
    }
    
    //Tabulating params
    NSInteger a = -10;
    NSInteger b = 10;
    CGFloat step = 0.5;
    
    [calcModel functionTabulator: functionToTabulate andRange:a andEnd:b andStep:step];
    
    self.transferingDataX = calcModel.tabulatedXdata;
    self.transferingDataY = calcModel.tabulatedYdata;
    
}

- (IBAction)goToLandscapeButton:(id)sender {
}

- (IBAction)styleChanger:(id)sender {
    
    AudioServicesPlaySystemSound(1057);
    
    
    if (self.styleChangeButtonPressed == YES) {
        
        
        UIImage* myBackgroundImage = [UIImage imageNamed: @"nature1.png"];
        UIImage *myBackgroundImageBlurred = [self.uiDesignMethods blurWithCoreImage: myBackgroundImage andUIView: self.view];
        self.view.backgroundColor = [UIColor colorWithPatternImage: myBackgroundImageBlurred];
        NSLog(@"Blured background set!\n\n");
        
        [self.uiDesignMethods animationsMaker: self.view duration: 0.20 speed: 0.50];
        
        self.styleChangeButtonPressed = NO;
        
    }
    else {
        
        UIImage* myBackgroundImage = [UIImage imageNamed: @"girl.png"];
        UIImage *myBackgroundImageBlurred = [self.uiDesignMethods blurWithCoreImage: myBackgroundImage andUIView: self.view];
        self.view.backgroundColor = [UIColor colorWithPatternImage:myBackgroundImageBlurred];
        NSLog(@"Blured background set!\n\n");
        
        [self.uiDesignMethods animationsMaker: self.view duration: 0.20 speed: 0.50];
        
        self.styleChangeButtonPressed = YES;
        
    }
    
}

@end
