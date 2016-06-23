//
//  ViewController.m
//  dreamCalc
//
//  Created by Yura Yasinskyy on 15.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()

@end


@implementation ViewController

@synthesize alpha, radius, numberOfButtons, screenBound, screenWidth, screenHeight, previousX, previousY, calculatedX, calculatedY, buttonEquals, buttonPlus, buttonMinus, buttonMultiply, buttonDivide, buttonComma, buttonErase, buttonBracketRight, buttonBracketLeft, buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive, buttonSix, buttonSeven, buttonEight, buttonNine, buttonZero, inputLabel, countOfLeftBrackets, countOfRightBrackets, isResultDisplayed, tempInput, dreamLabel, algorithmChanger, buttonPressed, styleChanger;

- (void) calculateXY: (NSMutableArray*) buttonsArray andArraySize: (int) arraySize {
    
    double rX, rY, c, s;
    
    for (int i = 0; i < arraySize; i++) {
        
        rX = previousX - screenWidth/2;
        rY = previousY - screenHeight/2;
        c = cos(alpha);
        s = sin(alpha);
        calculatedX = screenWidth/2 + rX*c - rY*s;
        calculatedY = screenHeight/2 + rX*s + rY*c;
        previousX = calculatedX;
        previousY = calculatedY;
        NSLog(@"Calculated X: %g Y: %g", calculatedX, calculatedY);
        CGPoint centerPoint = {calculatedX, calculatedY};
        [[buttonsArray objectAtIndex: i] setCenter:(centerPoint)];
        
    }
    
}





- (UIImage *)blurWithCoreImage:(UIImage *)sourceImage
{
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    // Apply Affine-Clamp filter to stretch the image so that it does not
    // look shrunken when gaussian blur is applied
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    // Apply gaussian blur filter with radius of 30
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:@15 forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[inputImage extent]];
    
    // Set up output context.
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    
    // Invert image coordinates
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.view.frame.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, self.view.frame, cgImage);
    
    // Apply white tint
    CGContextSaveGState(outputContext);
    CGContextSetFillColorWithColor(outputContext, [UIColor colorWithWhite:1 alpha:0.001].CGColor);
    CGContextFillRect(outputContext, self.view.frame);
    CGContextRestoreGState(outputContext);
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-25);
    verticalMotionEffect.maximumRelativeValue = @(25);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-25);
    horizontalMotionEffect.maximumRelativeValue = @(25);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [dreamLabel addMotionEffect:group];
    [inputLabel addMotionEffect:group];
    [algorithmChanger addMotionEffect:group];
    [styleChanger addMotionEffect:group];
    [buttonEquals addMotionEffect:group];
    
    [buttonOne addMotionEffect:group];
    [buttonTwo addMotionEffect:group];
    [buttonThree addMotionEffect:group];
    [buttonFour addMotionEffect:group];
    [buttonFive addMotionEffect:group];
    [buttonSix addMotionEffect:group];
    [buttonSeven addMotionEffect:group];
    [buttonEight addMotionEffect:group];
    [buttonNine addMotionEffect:group];
    [buttonZero addMotionEffect:group];
    
    [buttonPlus addMotionEffect:group];
    [buttonMinus addMotionEffect:group];
    [buttonMultiply addMotionEffect:group];
    [buttonDivide addMotionEffect:group];
    [buttonComma addMotionEffect:group];
    [buttonErase addMotionEffect:group];
    [buttonBracketLeft addMotionEffect:group];
    [buttonBracketRight addMotionEffect:group];
    
    

    [self setNeedsStatusBarAppearanceUpdate];
    
    //takes screenshot
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
//        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
//    else
//        UIGraphicsBeginImageContext(self.view.bounds.size);
//    
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    UIImage* myImage = [UIImage imageNamed:@"3.jpg"];
    NSLog(@"Background picture found!");
    
    UIImage *myImageBlurred = [self blurWithCoreImage:myImage];
    NSLog(@"Blurring done!");
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:myImageBlurred];
    
    
    countOfRightBrackets = 0;
    countOfLeftBrackets = 0;
    
    inputLabel.text = @"0";
    
    screenBound = [[UIScreen mainScreen] bounds];
    screenWidth = CGRectGetWidth(screenBound);
    screenHeight = CGRectGetHeight(screenBound);
    NSLog(@"Screen width: %g", screenWidth);
    NSLog(@"Screen height: %g", screenHeight); //just to see
    
    buttonEquals.center = CGPointMake(screenWidth/2, screenHeight/2); //centering '=' button
    
    numberOfButtons = 8;
    alpha = 6.2831/numberOfButtons;
    radius = 64;
    
    /* --- making inner buttons circle --- */
    
    buttonPlus.center = CGPointMake(screenWidth/2, screenHeight/2 - radius); //centering '+' button relatively '='
    previousX = screenWidth/2;
    previousY = screenHeight/2 - radius;
    
    NSMutableArray *innerButtonsArray = [NSMutableArray arrayWithCapacity: numberOfButtons - 1];
    [innerButtonsArray addObject:buttonMinus];
    [innerButtonsArray addObject:buttonMultiply];
    [innerButtonsArray addObject:buttonDivide];
    [innerButtonsArray addObject:buttonComma];
    [innerButtonsArray addObject:buttonErase];
    [innerButtonsArray addObject:buttonBracketRight];
    [innerButtonsArray addObject:buttonBracketLeft];
    
    /* positioning buttons in circle */
    NSLog(@"\nStarting inner circle now...");
    [self calculateXY: innerButtonsArray andArraySize:(numberOfButtons - 1)];
    
    /* --- making outter buttons circle --- */
    
    numberOfButtons = 10;
    alpha = 6.2831/numberOfButtons;
    radius = 125.0;

    buttonTwo.center = CGPointMake(screenWidth/2, screenHeight/2 - radius); //centering '2' button relatively '='
    previousX = screenWidth/2;
    previousY = screenHeight/2 - radius;
    

    NSMutableArray *outterButtonsArray = [NSMutableArray arrayWithCapacity: numberOfButtons - 1];
    [outterButtonsArray addObject:buttonThree];
    [outterButtonsArray addObject:buttonFour];
    [outterButtonsArray addObject:buttonFive];
    [outterButtonsArray addObject:buttonSix];
    [outterButtonsArray addObject:buttonSeven];
    [outterButtonsArray addObject:buttonEight];
    [outterButtonsArray addObject:buttonNine];
    [outterButtonsArray addObject:buttonZero];
    [outterButtonsArray addObject:buttonOne];
    
    /* positioning buttons in circle */
    NSLog(@"\nStarting outter circle now...");
    [self calculateXY: outterButtonsArray andArraySize:(numberOfButtons - 1)];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) parseUserInputFromLabel: (NSString*) text {
    
    NSString* labelInput;
    NSString* parsedString = @"";
    char element;
    
    //labelInput = @"77.0+(55-2)*4"; //after parsing should be 77.0 + ( 55 - 2 ) * 4
    labelInput = inputLabel.text;
    NSLog(@"text from input %@", labelInput);
    
    for (int i = 0; i < labelInput.length; i++) {
        
        if (([[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i] ]  isEqual: @"("] && [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i+1] ]  isEqual: @")"]) || (([[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i] ]  isEqual: @"("] && [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i+1] ]  isEqual: @"+"] && [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i+2] ]  isEqual: @")"]) || ([[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i] ]  isEqual: @"("] && [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i+1] ]  isEqual: @"-"] && [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i+2] ]  isEqual: @")"]) || ([[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i] ]  isEqual: @"("] && [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i+1] ]  isEqual: @"/"] && [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i+2] ]  isEqual: @")"]) || ([[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i] ]  isEqual: @"("] && [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i+1] ]  isEqual: @"*"] && [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i+2] ]  isEqual: @")"]) || ([[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i] ]  isEqual: @"("] && [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i+1] ]  isEqual: @"."] && [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i+2] ]  isEqual: @")"]))) {
            
            self.tempInput = inputLabel.text;
            return @"Are you sure everything is ok?";
         
        }
    }
    
    
//    int tempIncrementer = 0; //check for 5.5.5.5.. etc.
//    for (int i = 0; i < labelInput.length; i++) {
//        
//        if ( ([[NSString stringWithFormat:@"%c", [labelInput characterAtIndex: i]] isEqual:@"."]) && ([[NSString stringWithFormat:@"%c", [labelInput characterAtIndex: i+1]] doubleValue] != 0) && ([[NSString stringWithFormat:@"%c", [labelInput characterAtIndex: i+2]] isEqual:@"."])) {
//            
//            tempIncrementer++;
//        }
//    }
//    if (tempIncrementer > 1) {
//        
//        self.tempInput = inputLabel.text;
//        return @"Are you sure everything is ok?";
//    }
    
    
    for (int i = 0; i < labelInput.length; i++) {
        
        element = [labelInput characterAtIndex: i];
        
        if ([[NSString stringWithFormat:@"%c", element]  isEqual: @"("] || [[NSString stringWithFormat:@"%c", element]  isEqual: @")"] || [[NSString stringWithFormat:@"%c", element]  isEqual: @"+"] || [[NSString stringWithFormat:@"%c", element]  isEqual: @"-"] || [[NSString stringWithFormat:@"%c", element]  isEqual: @"*"] || [[NSString stringWithFormat:@"%c", element]  isEqual: @"/"]) {
            
            if (i == 0) {
                parsedString = [NSString stringWithFormat:@"%@%c", parsedString, element];
            }
            else {
                parsedString = [NSString stringWithFormat:@"%@ %c", parsedString, element];
            }
            continue;
        }
        else {
            
            if (i == 0) {
                
                parsedString = [NSString stringWithFormat:@"%@%c", parsedString, element];
            }
            else {
                if ([[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"("] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@")"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"+"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"-"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"*"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"/"]) {
                
                    parsedString = [NSString stringWithFormat:@"%@ %c", parsedString, element];
                }
                else {
                
                    parsedString = [NSString stringWithFormat:@"%@%c", parsedString, element];
            }
            }
            
        }
    }
    
    
    NSLog(@"parsed string: %@", parsedString);
    
    return parsedString;
    
}



- (IBAction)buttonOneTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1201);
    
    if ((isResultDisplayed == YES) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"/"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"*"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"+"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"-"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"."])) {
        
        inputLabel.text = @"1";
        isResultDisplayed = FALSE;
    }
    else {
    
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

}

- (IBAction)buttonTwoTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1202);
    
    if ((isResultDisplayed == YES) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"/"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"*"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"+"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"-"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"."])) {
        
        inputLabel.text = @"2";
        isResultDisplayed = FALSE;
    }
    else {
    
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
    
}

- (IBAction)buttonThreeTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1203);
    
    if ((isResultDisplayed == YES) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"/"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"*"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"+"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"-"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"."])) {
        
        inputLabel.text = @"3";
        isResultDisplayed = FALSE;
    }
    else {
    
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
    
}

- (IBAction)buttonFourTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1204);
    
    if ((isResultDisplayed == YES) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"/"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"*"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"+"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"-"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"."])) {
        
        inputLabel.text = @"4";
        isResultDisplayed = FALSE;
    }
    else {
    
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
    
}

- (IBAction)buttonFiveTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1205);
    
    if ((isResultDisplayed == YES) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"/"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"*"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"+"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"-"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"."])) {
        
        inputLabel.text = @"5";
        isResultDisplayed = FALSE;
    }
    else {
    
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
    
}

- (IBAction)buttonSixTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1206);
    
    if ((isResultDisplayed == YES) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"/"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"*"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"+"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"-"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"."])) {
        
        inputLabel.text = @"6";
        isResultDisplayed = FALSE;
    }
    else {
    
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
    
}

- (IBAction)buttonSevenTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1207);
    
  
    
    if ((isResultDisplayed == YES) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"/"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"*"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"+"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"-"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"."])) {
        
        inputLabel.text = @"7";
        isResultDisplayed = FALSE;
    }
    else {
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
    
}

- (IBAction)buttonEightTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1208);
    
    if ((isResultDisplayed == YES) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"/"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"*"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"+"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"-"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"."])) {
        
        inputLabel.text = @"8";
        isResultDisplayed = FALSE;
    }
    else {
    
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
    
}

- (IBAction)buttonNineTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1209);
    
    if ((isResultDisplayed == YES) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"/"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"*"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"+"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"-"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"."])) {
        
        inputLabel.text = @"9";
        isResultDisplayed = FALSE;
    }
    else {
    
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
    
}

- (IBAction)buttonZeroTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1200);
    
    if ((isResultDisplayed == YES) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"/"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"*"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"+"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"-"]) && (![[NSString stringWithFormat:@"%c", [inputLabel.text characterAtIndex:inputLabel.text.length - 1]] isEqual: @"."])) {
        
        inputLabel.text = @"0";
        isResultDisplayed = FALSE;
    }
    else {
    
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

- (IBAction)buttonEqualTouch:(id)sender {
    
    AudioServicesPlaySystemSound(1103);

    

    
    if ([[NSString stringWithFormat:@"%c",[inputLabel.text characterAtIndex:inputLabel.text.length - 1]]  isEqual: @"+"] || [[NSString stringWithFormat:@"%c",[inputLabel.text characterAtIndex:inputLabel.text.length - 1]]  isEqual: @"-"] || [[NSString stringWithFormat:@"%c",[inputLabel.text characterAtIndex:inputLabel.text.length - 1]]  isEqual: @"*"] || [[NSString stringWithFormat:@"%c",[inputLabel.text characterAtIndex:inputLabel.text.length - 1]]  isEqual: @"/"] || [[NSString stringWithFormat:@"%c",[inputLabel.text characterAtIndex:inputLabel.text.length - 1]]  isEqual: @"."]) {
        
        
        
        self.tempInput = inputLabel.text;
        inputLabel.text = @"Are you sure everything is ok?";
    }
    else {
    
        if ([inputLabel.text  isEqual: @"0"] || [inputLabel.text hasPrefix:@"N"] || [inputLabel.text hasPrefix:@"A"]) {
            
            if ([inputLabel.text  isEqual: @"0"]) {
                
                inputLabel.text = @"0";
            }
            else {
        
                inputLabel.text = self.tempInput;
            }
        }
        else {
            
            if (countOfLeftBrackets == countOfRightBrackets) {
                
                if ((countOfLeftBrackets == 1) && (inputLabel.text.length == 2)) {
                    
                    
                    inputLabel.text = @"No expression typed!";
                    self.tempInput = @"()";
                   
                }
                else {
                    
                    CalcModel* myModel = [[CalcModel alloc] init];
            
                    NSLog(@"%@", inputLabel.text);
                    NSMutableArray* arr1 = [[NSMutableArray alloc] init];
            
                    NSString* parsedString = [self parseUserInputFromLabel: inputLabel.text];
                    NSLog(@"%@", parsedString);
                    
                    if ([parsedString hasPrefix:@"A"]) {
                        
                        inputLabel.text = tempInput;
                    }
                    else {
                        
                        if (algorithmChanger.selectedSegmentIndex == 0) {
                            
                            NSLog(@"RPN ALGORITHM SELECTED");
                            arr1 = [myModel prepareToBackPolishing: parsedString];
                            
                            NSMutableArray* arr2 = [[NSMutableArray alloc] init];
                            arr2 = [myModel backPolishing: arr1];
                            
                            double result;
                            result = [myModel calculatingResult:arr2];
                            
                            NSLog(@"%f", result);
                            
                            inputLabel.text = [NSString stringWithFormat:@"%g", result];
                            isResultDisplayed = YES;
                        }
                        else if (algorithmChanger.selectedSegmentIndex == 1) {
                            
                            NSLog(@"NSEXPRESSION ALGORITHM SELECTED");
                            NSString *numericExpression = parsedString;
                            NSExpression *expression = [NSExpression expressionWithFormat:numericExpression];
                            NSNumber *result = [expression expressionValueWithObject:nil context:nil];
                            
                            NSLog(@"%@", result);
                            
                            inputLabel.text = [NSString stringWithFormat:@"%@", result];
                            isResultDisplayed = YES;
                        }
                    
//                            arr1 = [myModel prepareToBackPolishing: parsedString];
//            
//                            NSMutableArray* arr2 = [[NSMutableArray alloc] init];
//                            arr2 = [myModel backPolishing: arr1];
//            
//                            double result;
//                            result = [myModel calculatingResult:arr2];
//            
//                            NSLog(@"%f", result);
//            
//                            inputLabel.text = [NSString stringWithFormat:@"%g", result];
//                            isResultDisplayed = YES;
                        }
                    
                    
                }
                
            }
            else {
                
                
                self.tempInput = inputLabel.text;
                inputLabel.text = @"Not enough brackets!";
                
                
            }
    
        
        }
    }
    
    

}




- (IBAction)styleChanger:(id)sender {
    
    
    
    if (buttonPressed == YES) {
        UIImage* myImage = [UIImage imageNamed:@"3.jpg"];
        NSLog(@"Background picture found!");
        
        UIImage *myImageBlurred = [self blurWithCoreImage:myImage];
        NSLog(@"Blurring done!");
        
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:myImageBlurred];
        
        buttonPressed = NO;

    }
    else {
    
        UIImage* myImage = [UIImage imageNamed:@"girl.png"];
        NSLog(@"Background picture found!");
    
        UIImage *myImageBlurred = [self blurWithCoreImage:myImage];
        NSLog(@"Blurring done!");
    
    
        self.view.backgroundColor = [UIColor colorWithPatternImage:myImageBlurred];
    
        buttonPressed = YES;
    }


}

@end
