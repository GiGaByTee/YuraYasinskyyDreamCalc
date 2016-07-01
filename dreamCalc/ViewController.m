//
//  ViewController.m
//  dreamCalc
//
//  Created by Yura Yasinskyy on 15.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


@implementation ViewController

@synthesize radius, screenBound, screenWidth, screenHeight, buttonEquals, buttonPlus, buttonMinus, buttonMultiply, buttonDivide, buttonComma, buttonErase, buttonBracketRight, buttonBracketLeft, buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive, buttonSix, buttonSeven, buttonEight, buttonNine, buttonZero, inputLabel, countOfLeftBrackets, countOfRightBrackets, dreamLabel, algorithmChanger, styleChangeButtonPressed, styleChanger, myUI, buttonsCenterOffset, buttonSin, buttonCos, buttonTan, buttonCtg, scientificSwitch, upperScientificFunctions, turboModeLabel, buttonPower, buttonSecondView, buttonX, buttonY,transferingDataX, transferingDataY, buttonTabulate, isYPressed;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UITapGestureRecognizer *tapper=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [inputLabel addGestureRecognizer:tapper];
    
    
    buttonSin.hidden = YES;
    buttonCos.hidden = YES;
    buttonTan.hidden = YES;
    buttonCtg.hidden = YES;
    buttonPower.hidden = YES;
    buttonSecondView.hidden = YES;
    buttonX.hidden = YES;
    buttonY.hidden = YES;
    buttonTabulate.hidden = YES;
    algorithmChanger.hidden = NO;
    
    //Class with UI methods
    myUI = [[UIDesign alloc] init];
    NSLog(@"UI class initialised.");
    
    //Sets white statusbar text color
    [self preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
    NSLog(@"Statusbar style set.");
    
    //Making arrays with views and setting parallax effect
    NSMutableArray* innerCircleButtons = [[NSMutableArray alloc] init];
    [innerCircleButtons addObject: buttonPlus];
    [innerCircleButtons addObject: buttonMinus];
    [innerCircleButtons addObject: buttonMultiply];
    [innerCircleButtons addObject: buttonDivide];
    [innerCircleButtons addObject: buttonComma];
    [innerCircleButtons addObject: buttonErase];
    [innerCircleButtons addObject: buttonBracketRight];
    [innerCircleButtons addObject: buttonBracketLeft];
    
    NSMutableArray* outerCircleButtons = [[NSMutableArray alloc] init];
    [outerCircleButtons addObject: buttonTwo];
    [outerCircleButtons addObject: buttonThree];
    [outerCircleButtons addObject: buttonFour];
    [outerCircleButtons addObject: buttonFive];
    [outerCircleButtons addObject: buttonSix];
    [outerCircleButtons addObject: buttonSeven];
    [outerCircleButtons addObject: buttonEight];
    [outerCircleButtons addObject: buttonNine];
    [outerCircleButtons addObject: buttonZero];
    [outerCircleButtons addObject: buttonOne];
    
    upperScientificFunctions = [[NSMutableArray alloc] init];
    [upperScientificFunctions addObject: buttonSin];
    [upperScientificFunctions addObject: buttonCos];
    [upperScientificFunctions addObject: buttonTan];
    [upperScientificFunctions addObject: buttonCtg];
    [upperScientificFunctions addObject: buttonPower];
    [upperScientificFunctions addObject: buttonY];
    [upperScientificFunctions addObject: buttonX];
    [upperScientificFunctions addObject: buttonSecondView];
    
    NSMutableArray* otherViews = [[NSMutableArray alloc] init]; //labels etc.
    [otherViews addObject: dreamLabel];
    [otherViews addObject: inputLabel];
    [otherViews addObject: algorithmChanger];
    [otherViews addObject: styleChanger];
    [otherViews addObject: buttonEquals];
    [otherViews addObject: scientificSwitch];
    [otherViews addObject: turboModeLabel];

    [myUI parallaxImplementor: innerCircleButtons];
    [myUI parallaxImplementor: outerCircleButtons];
    [myUI parallaxImplementor: upperScientificFunctions];
    [myUI parallaxImplementor: otherViews];
    NSLog(@"Parallax effect set.");
    
    //Setting blured background image
    UIImage* myBackgroundImage = [UIImage imageNamed:@"galaxy1.png"];
    NSLog(@"Background picture found.");
    
    UIImage *myBackgroundImageBlurred = [myUI blurWithCoreImage: myBackgroundImage andUIView: self.view];
    NSLog(@"Blurring done.");
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: myBackgroundImageBlurred];
    NSLog(@"Background set.\n\n");
    
    
    //Getting size of the screen
    screenBound = [[UIScreen mainScreen] bounds];
    screenWidth = CGRectGetWidth(screenBound);
    screenHeight = CGRectGetHeight(screenBound);
    
    buttonsCenterOffset = 25;
    
    //Positioning equals button in the center of the view
    buttonEquals.center = CGPointMake(screenWidth/2, screenHeight/2+buttonsCenterOffset); //centering '=' button
    
    //Positioning inner circle buttons
    radius = 64.0;
    buttonPlus.center = CGPointMake(screenWidth/2, screenHeight/2 - radius+buttonsCenterOffset); //centering '+' button relatively '='
    [myUI calculateXY:innerCircleButtons andPreferedRadius: radius andScreenBounds: &(screenBound) offset: buttonsCenterOffset];
    NSLog(@"Inner circle of buttons formed.");
    
    //Positioning outer circle buttons
    radius = 125.0;
    buttonTwo.center = CGPointMake(screenWidth/2, screenHeight/2 - radius+buttonsCenterOffset); //centering '2' button relatively '='
    NSLog(@"Starting outter circle now...");
    [myUI calculateXY: outerCircleButtons andPreferedRadius: radius andScreenBounds: &(screenBound) offset: buttonsCenterOffset];
    NSLog(@"Outer circle of buttons formed.");
    
    
    
    //Positioning scientific buttons
    buttonPower.center = CGPointMake(buttonOne.center.x-1, buttonOne.center.y-81);
    buttonY.center = CGPointMake(buttonPower.center.x+50, buttonPower.center.y);
    buttonX.center = CGPointMake(buttonY.center.x+50, buttonY.center.y);
    buttonSecondView.center = CGPointMake(buttonX.center.x+50, buttonX.center.y);
    
    buttonSin.center = CGPointMake(buttonEight.center.x-1, buttonEight.center.y+81);
    buttonCos.center = CGPointMake(buttonSin.center.x+50, buttonSin.center.y);
    buttonTan.center = CGPointMake(buttonCos.center.x+50, buttonCos.center.y);
    buttonCtg.center = CGPointMake(buttonTan.center.x+50, buttonTan.center.y);
    
    
    
    countOfRightBrackets = 0;
    countOfLeftBrackets = 0;
    
    inputLabel.text = @"0";
    
    // Do any additional setup after loading the view, typically from a nib.
}



-(void) tapped:(UIGestureRecognizer *) sender {

    if ([inputLabel.text isEqualToString:@"0"] || inputLabel.text.length == 1) {
        
        inputLabel.text = @"0";
    }
    else {
    
        NSString *newString = [inputLabel.text substringToIndex:[inputLabel.text length]-1];
    
        inputLabel.text = newString;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

- (IBAction)buttonEqualTouch:(id)sender {
    
    
    AudioServicesPlaySystemSound(1033);
    
    if (isYPressed) {
        
        inputLabel.text = @"Are you sure everything is ok?";
    }
    else {
    
    CalcModel* myModel = [[CalcModel alloc] init];
    NSString* stringAfterRegex;
    
    NSLog(@"%@", inputLabel.text);
    
    
    if (countOfLeftBrackets != countOfRightBrackets) {
        
        inputLabel.text = @"Not enough brackets :(";
        countOfLeftBrackets = countOfRightBrackets = 0;
    }
    else {
            
            stringAfterRegex = [myModel regexSyntaxCheker:inputLabel.text];
        
    
        if ([stringAfterRegex hasPrefix:@"A"]) {
        
            inputLabel.text = @"Are you sure everything is ok?";
        }
        else {
        
        
            NSString* parsedString = [myModel parseUserInputFromLabel: stringAfterRegex];
            NSLog(@"%@", parsedString);
        
        
        
            if (algorithmChanger.selectedSegmentIndex == 0) {
            
                NSLog(@"RPN ALGORITHM SELECTED");
                NSMutableArray* arr1;
                arr1 = [myModel prepareToBackPolishing: parsedString];
            
                NSMutableArray* arr2;
                arr2 = [myModel backPolishing: arr1];
            
                CGFloat result;
                result = [myModel calculatingResult:arr2];
            
                NSLog(@"%f", result);

            
                inputLabel.text = [NSString stringWithFormat:@"%g", result];
                
            }
            else if (algorithmChanger.selectedSegmentIndex == 1) {
            
                NSLog(@"NSEXPRESSION ALGORITHM SELECTED");
                NSString *numericExpression = parsedString;
                NSExpression *expression = [NSExpression expressionWithFormat:numericExpression];
                NSNumber *result = [expression expressionValueWithObject:nil context:nil];
            
                NSLog(@"%@", result);
                

                    inputLabel.text = [NSString stringWithFormat:@"%@", result];
                
            }
        }
    
    }
        
        
    }
    
}

- (IBAction)buttonOneTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1201);
    
        
        if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
            
            inputLabel.text = @"1";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
                
                inputLabel.text = @"1";
            }
            else {
                
                inputLabel.text = [NSString stringWithFormat:@"%@1", inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonTwoTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1202);
    
        
        if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
            
            inputLabel.text = @"2";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
                
                inputLabel.text = @"2";
            }
            else {
                
                inputLabel.text = [NSString stringWithFormat:@"%@2", inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonThreeTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1203);
    
        
        if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
            
            inputLabel.text = @"3";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
                
                inputLabel.text = @"3";
            }
            else {
                
                inputLabel.text = [NSString stringWithFormat:@"%@3", inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonFourTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1204);
    

        
        if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
            
            inputLabel.text = @"4";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
                
                inputLabel.text = @"4";
            }
            else {
                
                inputLabel.text = [NSString stringWithFormat:@"%@4", inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonFiveTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1205);
    
        
        if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
            
            inputLabel.text = @"5";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
                
                inputLabel.text = @"5";
            }
            else {
                
                inputLabel.text = [NSString stringWithFormat:@"%@5", inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonSixTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1206);
    

        
        if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
            
            inputLabel.text = @"6";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
                
                inputLabel.text = @"6";
            }
            else {
                
                inputLabel.text = [NSString stringWithFormat:@"%@6", inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonSevenTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1207);
    
    
    

        if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
            
            inputLabel.text = @"7";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
                
                inputLabel.text = @"7";
            }
            else {
                
                inputLabel.text = [NSString stringWithFormat:@"%@7", inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonEightTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1208);
    

        
        if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
            
            inputLabel.text = @"8";
        }
        else {
            if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
                
                inputLabel.text = @"8";
            }
            else {
                
                inputLabel.text = [NSString stringWithFormat:@"%@8", inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonNineTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1209);
    

        
        if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
            
            inputLabel.text = @"9";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
                
                inputLabel.text = @"9";
            }
            else {
                
                inputLabel.text = [NSString stringWithFormat:@"%@9", inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonZeroTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1200);
    

        
        if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
            
            inputLabel.text = @"0";
        }
        else {
            
            if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
                
                inputLabel.text = @"0";
            }
            else {
                
                inputLabel.text = [NSString stringWithFormat:@"%@0", inputLabel.text];
            }
        }
    
    
}

- (IBAction)buttonPlusTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
            
            inputLabel.text = @"0+";
        }
        else {
            
            inputLabel.text = [NSString stringWithFormat:@"%@+", inputLabel.text];
        }
    }
    
}

- (IBAction)buttonMinusTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
            
            inputLabel.text = @"0-";
        }
        else {
            
            inputLabel.text = [NSString stringWithFormat:@"%@-", inputLabel.text];
        }
    }
    
}

- (IBAction)buttonMultiplyTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
            
            inputLabel.text = @"0*";
        }
        else {
            
            inputLabel.text = [NSString stringWithFormat:@"%@*", inputLabel.text];
        }
    }
    
}

- (IBAction)buttonDivideTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
            
            inputLabel.text = @"0/";
        }
        else {
            
            inputLabel.text = [NSString stringWithFormat:@"%@/", inputLabel.text];
        }
    }
    
}

- (IBAction)buttonCommaTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @"0";
    }
    else {
        
        inputLabel.text = [NSString stringWithFormat:@"%@.", inputLabel.text];
    }
    
}

- (IBAction)buttonClearTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    inputLabel.text=@"0";
    countOfLeftBrackets = 0;
    countOfRightBrackets = 0;
    
}

- (IBAction)buttonRightBracketTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @")";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
            
            inputLabel.text = @"0";
        }
        else {
            
            inputLabel.text = [NSString stringWithFormat:@"%@)", inputLabel.text];
        }
    }
    
    countOfRightBrackets++;
    
}

- (IBAction)buttonLeftBracketTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @"(";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
            
            inputLabel.text = @"(";
        }
        else {
            
            inputLabel.text = [NSString stringWithFormat:@"%@(", inputLabel.text];
        }
    }
    
    countOfLeftBrackets++;
    
}

- (IBAction)styleChanger:(id)sender {
    
    AudioServicesPlaySystemSound(1057);
    
    
    if (styleChangeButtonPressed == YES) {
        
        
        UIImage* myBackgroundImage = [UIImage imageNamed: @"nature1.png"];
        NSLog(@"Background picture found!");
        
        UIImage *myBackgroundImageBlurred = [myUI blurWithCoreImage: myBackgroundImage andUIView: self.view];
        NSLog(@"Blurring done!");
        
        self.view.backgroundColor = [UIColor colorWithPatternImage: myBackgroundImageBlurred];
        NSLog(@"Background set!");
        
        [myUI animationsMaker: self.view duration: 0.20 speed: 0.50];
        
        styleChangeButtonPressed = NO;
        
        
    }
    else {
        
        UIImage* myBackgroundImage = [UIImage imageNamed: @"girl.png"];
        NSLog(@"Background picture found!");
        
        UIImage *myBackgroundImageBlurred = [myUI blurWithCoreImage: myBackgroundImage andUIView: self.view];
        NSLog(@"Blurring done!");
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:myBackgroundImageBlurred];
        NSLog(@"Background set!");
        
        [myUI animationsMaker: self.view duration: 0.20 speed: 0.50];
        
        styleChangeButtonPressed = YES;
        
    }
    
}













- (IBAction)buttonSinTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    
    
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
            
            
            inputLabel.text = @"sin(";
        }
        else {
            
            inputLabel.text = [NSString stringWithFormat:@"%@sin(", inputLabel.text];
        }
        
        countOfLeftBrackets++;
    }
    
    
}

- (IBAction)buttonCosTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
            
            
            inputLabel.text = @"cos(";
        }
        else {
            
            inputLabel.text = [NSString stringWithFormat:@"%@cos(", inputLabel.text];
        }
        
        countOfLeftBrackets++;
    }

    
}

- (IBAction)buttonTanTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
            
            
            inputLabel.text = @"tan(";
        }
        else {
            
            inputLabel.text = [NSString stringWithFormat:@"%@tan(", inputLabel.text];
        }
        
        countOfLeftBrackets++;
    }
    
}

- (IBAction)buttonCtgTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
            
            
            inputLabel.text = @"ctg(";
        }
        else {
            
            inputLabel.text = [NSString stringWithFormat:@"%@ctg(", inputLabel.text];
        }
        
        countOfLeftBrackets++;
    }
    

    
}

- (IBAction)buttonExpTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    inputLabel.text = @"exp()";
}

- (IBAction)buttonPowerTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
            
            inputLabel.text = @"0^";
        }
        else {
            
            inputLabel.text = [NSString stringWithFormat:@"%@^", inputLabel.text];
        }
    }
}

- (IBAction)buttonSqrtTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    inputLabel.text = @"sqrt()";
}

- (IBAction)buttonFactorialTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    inputLabel.text = @"fac()";
}

- (IBAction)scientificFunctionsEnabler:(id)sender {
    
    AudioServicesPlaySystemSound(1004);

    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.20;
    transition.speed = 0.50;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.delegate = self;
    
    
    if ([scientificSwitch isOn]) {
        
        for (NSInteger i = 0; i < upperScientificFunctions.count; i++) {
            
            UIView* viewElement = [upperScientificFunctions objectAtIndex: i];
            [viewElement.layer addAnimation:transition forKey:nil];
        }
        
        buttonSin.hidden = NO;
        buttonCos.hidden = NO;
        buttonTan.hidden = NO;
        buttonCtg.hidden = NO;
        buttonPower.hidden = NO;
        buttonSecondView.hidden = NO;
        buttonX.hidden = NO;
        buttonY.hidden = NO;
        
    }
    else {
        
        for (NSInteger i = 0; i < upperScientificFunctions.count; i++) {
            
            UIView* viewElement = [upperScientificFunctions objectAtIndex: i];
            [viewElement.layer addAnimation:transition forKey:nil];
        }
        
        buttonSin.hidden = YES;
        buttonCos.hidden = YES;
        buttonTan.hidden = YES;
        buttonCtg.hidden = YES;
        buttonPower.hidden = YES;
        buttonSecondView.hidden = YES;
        buttonX.hidden = YES;
        buttonY.hidden = YES;
    }
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    CalcModel* calcModel = [[CalcModel alloc] init];
    
    transferingDataX = [[NSMutableArray alloc] init];
    transferingDataY = [[NSMutableArray alloc] init];
    
    
    NSString *func = @"";
    

    
    //Tabulating params
    NSInteger a = -10;
    NSInteger b = 10;
    CGFloat step = 0.5;
    
    NSString* stringAfterRegex;
    
    if (countOfLeftBrackets != countOfRightBrackets) {
        
        countOfLeftBrackets = countOfRightBrackets = 0;
        
        if([segue.identifier isEqualToString:@"goToPlotViewSegue"]){
            SecondViewController *seconViewController = (SecondViewController *)segue.destinationViewController;
            
            seconViewController.labelTextTransfer = @"Are you sure everything is ok?";
            
            
        }
        
        
        
    } else {
        
        stringAfterRegex = [calcModel regexSyntaxCheker:inputLabel.text];
        
        if ([stringAfterRegex hasPrefix:@"A"] || [stringAfterRegex hasPrefix:@"N"]) {
            
            
            inputLabel.text = @"Are you sure everything is ok?";
            if([segue.identifier isEqualToString:@"goToPlotViewSegue"]){
                SecondViewController *seconViewController = (SecondViewController *)segue.destinationViewController;
                
                seconViewController.labelTextTransfer = inputLabel.text;
                
                
            }
            

        }
        else {
            
        NSString* parsedString = [calcModel parseUserInputFromLabel: stringAfterRegex];
        NSLog(@"%@", parsedString);
            
        for (int i = 2; i < parsedString.length; i++) {
                
            func = [NSString stringWithFormat:@"%@%c", func, [parsedString characterAtIndex:i]];
        }
        
        
        [calcModel functionTabulator:func andRange:a andEnd:b andStep:step];
        
        transferingDataX = calcModel.tabulatedXdata;
        transferingDataY = calcModel.tabulatedYdata;
        
        
        if([segue.identifier isEqualToString:@"goToPlotViewSegue"]){
            SecondViewController *seconViewController = (SecondViewController *)segue.destinationViewController;
            seconViewController.dataToTransferX = transferingDataX;
            seconViewController.dataToTransferY = transferingDataY;
            seconViewController.dataLength = transferingDataX.count;
            
            seconViewController.labelTextTransfer = inputLabel.text;
            
            
        }
        }
        
        
    }
    
    
    

    
    
}



- (IBAction)showSecondView:(id)sender {
    
    
    NSLog(@"Switched to second view.");
    AudioServicesPlaySystemSound(1004);
    
    
    

    
    
}

- (IBAction)buttonXTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    //inputLabel.text = [NSString stringWithFormat:@"%@x", inputLabel.text];
    
    if ([inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
        
        inputLabel.text = @"0";
    }
    else {
        
        if ([[NSString stringWithFormat:@"%@", inputLabel.text] isEqual:@"0"]) {
            
            inputLabel.text = @"0";
        }
        else {
            
            inputLabel.text = [NSString stringWithFormat:@"%@x", inputLabel.text];
        }
    }
    
}
- (IBAction)buttonYTouch:(id)sender {
    
    AudioServicesPlaySystemSound(0x450);
    
    inputLabel.text = @"y=";
    
    
    isYPressed = YES;
    

    
    
}

- (IBAction)tabulateButtonTouch:(id)sender {
    
    
    CalcModel* calcModel = [[CalcModel alloc] init];
    
    transferingDataX = [[NSMutableArray alloc] init];
    transferingDataY = [[NSMutableArray alloc] init];
    
    
    NSString *func = @"";
    
    for (int i = 2; i < inputLabel.text.length; i++) {
        
        func = [NSString stringWithFormat:@"%@%c", func, [inputLabel.text characterAtIndex:i]];
    }
    
    //Tabulating params
    NSInteger a = -10;
    NSInteger b = 10;
    CGFloat step = 0.5;
    
    
    [calcModel functionTabulator:func andRange:a andEnd:b andStep:step];
    
    transferingDataX = calcModel.tabulatedXdata;
    transferingDataY = calcModel.tabulatedYdata;
    
    
    
    
}
@end
