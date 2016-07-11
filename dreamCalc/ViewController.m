//
//  ViewController.m
//  dreamCalc
//
//  Created by Yura Yasinskyy on 15.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

// internal properties
@property(nonatomic) CGFloat radius;

@property(nonatomic) CGFloat screenWidth;

@property(nonatomic) CGFloat screenHeight;

@property(nonatomic) NSInteger buttonsCenterOffset;

@property(nonatomic) NSInteger countOfLeftBrackets;

@property(nonatomic) NSInteger countOfRightBrackets;

@property BOOL isYPressed;

@property(strong, nonatomic) UIDesignMethods* uiDesignMethods;

@property(strong, nonatomic) NSMutableArray* upperScientificFunctions;

@property(strong, nonatomic) NSMutableArray* innerCircleButtons;

@property(strong, nonatomic) NSMutableArray* outerCircleButtons;

@property(strong, nonatomic) NSMutableArray* otherViews;

@property BOOL styleChangeButtonPressed;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  UITapGestureRecognizer* tapper =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tapRecognizer:)];
  [self.inputLabel addGestureRecognizer:tapper];

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

  // Class with UI methods
  self.uiDesignMethods = [[UIDesignMethods alloc] init];
  NSLog(@"UI class initialised.");

  // Sets white statusbar text color
  [self preferredStatusBarStyle];
  [self setNeedsStatusBarAppearanceUpdate];
  NSLog(@"Statusbar style set.");

  // Getting size of the screen
  self.screenBound = [[UIScreen mainScreen] bounds];
  self.screenWidth = CGRectGetWidth(self.screenBound);
  self.screenHeight = CGRectGetHeight(self.screenBound);

  // Making arrays with views and setting parallax effect
  self.innerCircleButtons = [[NSMutableArray alloc] init];
  [self.innerCircleButtons addObject:self.buttonPlus];
  [self.innerCircleButtons addObject:self.buttonMinus];
  [self.innerCircleButtons addObject:self.buttonMultiply];
  [self.innerCircleButtons addObject:self.buttonDivide];
  [self.innerCircleButtons addObject:self.buttonComma];
  [self.innerCircleButtons addObject:self.buttonErase];
  [self.innerCircleButtons addObject:self.buttonBracketRight];
  [self.innerCircleButtons addObject:self.buttonBracketLeft];

  self.outerCircleButtons = [[NSMutableArray alloc] init];
  [self.outerCircleButtons addObject:self.buttonTwo];
  [self.outerCircleButtons addObject:self.buttonThree];
  [self.outerCircleButtons addObject:self.buttonFour];
  [self.outerCircleButtons addObject:self.buttonFive];
  [self.outerCircleButtons addObject:self.buttonSix];
  [self.outerCircleButtons addObject:self.buttonSeven];
  [self.outerCircleButtons addObject:self.buttonEight];
  [self.outerCircleButtons addObject:self.buttonNine];
  [self.outerCircleButtons addObject:self.buttonZero];
  [self.outerCircleButtons addObject:self.buttonOne];

  self.upperScientificFunctions = [[NSMutableArray alloc] init];
  [self.upperScientificFunctions addObject:self.buttonSin];
  [self.upperScientificFunctions addObject:self.buttonCos];
  [self.upperScientificFunctions addObject:self.buttonTan];
  [self.upperScientificFunctions addObject:self.buttonCtg];
  [self.upperScientificFunctions addObject:self.buttonPower];
  [self.upperScientificFunctions addObject:self.buttonY];
  [self.upperScientificFunctions addObject:self.buttonX];
  [self.upperScientificFunctions addObject:self.buttonSecondView];

  self.otherViews = [[NSMutableArray alloc] init];  // labels etc.
  [self.otherViews addObject:self.dreamLabel];
  [self.otherViews addObject:self.inputLabel];
  [self.otherViews addObject:self.algorithmChanger];
  [self.otherViews addObject:self.styleChanger];
  [self.otherViews addObject:self.buttonEquals];
  [self.otherViews addObject:self.scientificSwitch];
  [self.otherViews addObject:self.turboModeLabel];

  [self.uiDesignMethods parallaxImplementor:[self.innerCircleButtons copy]];
  [self.uiDesignMethods parallaxImplementor:[self.outerCircleButtons copy]];
  [self.uiDesignMethods
      parallaxImplementor:[self.upperScientificFunctions copy]];
  [self.uiDesignMethods parallaxImplementor:[self.otherViews copy]];
  NSLog(@"Parallax effect set.");

  // Setting blured background image
  UIImage* myBackgroundImage = [UIImage imageNamed:@"galaxy.jpg"];

  // UIImage *myBackgroundImageBlurred = [self.uiDesignMethods
  // blurWithCoreImage: myBackgroundImage andUIView: self.view];
  self.view.backgroundColor = [UIColor colorWithPatternImage:myBackgroundImage];
  NSLog(@"BluredBackground set.\n\n");

  self.buttonsCenterOffset =
      self.screenHeight /
      26.68;  // to move button a bit down for a beeter reachebility

  // Positioning equals button in the center of the view
  self.buttonEquals.center =
      CGPointMake(self.screenWidth / 2,
                  self.screenHeight / 2 +
                      self.buttonsCenterOffset);  // centering '=' button

  // Positioning inner circle buttons
  self.radius = 64.0;
  self.buttonPlus.center = CGPointMake(
      self.screenWidth / 2,
      self.screenHeight / 2 - self.radius +
          self.buttonsCenterOffset);  // centering '+' button relatively '='
  [self.uiDesignMethods positioningObjectsInCircle:self.innerCircleButtons
                                 andPreferedRadius:self.radius
                                   andScreenBounds:&(_screenBound)
                                 andVerticalOffset:self.buttonsCenterOffset];
  NSLog(@"Inner circle of buttons formed.\n\n");

  // Positioning outer circle buttons
  self.radius = 125.0;
  self.buttonTwo.center = CGPointMake(
      self.screenWidth / 2,
      self.screenHeight / 2 - self.radius +
          self.buttonsCenterOffset);  // centering '2' button relatively '='
  [self.uiDesignMethods positioningObjectsInCircle:self.outerCircleButtons
                                 andPreferedRadius:self.radius
                                   andScreenBounds:&(_screenBound)
                                 andVerticalOffset:self.buttonsCenterOffset];
  NSLog(@"Outer circle of buttons formed.\n\n");

  // Positioning scientific buttons
  NSInteger scientificButtonsHorizontalOffset = 50;
  NSInteger scientificButtonsVerticalOffset = 81;
  self.buttonPower.center =
      CGPointMake(self.buttonOne.center.x - 1,
                  self.buttonOne.center.y - scientificButtonsVerticalOffset);
  self.buttonY.center =
      CGPointMake(self.buttonPower.center.x + scientificButtonsHorizontalOffset,
                  self.buttonPower.center.y);
  self.buttonX.center =
      CGPointMake(self.buttonY.center.x + scientificButtonsHorizontalOffset,
                  self.buttonY.center.y);
  self.buttonSecondView.center =
      CGPointMake(self.buttonX.center.x + scientificButtonsHorizontalOffset,
                  self.buttonX.center.y);
  self.buttonSin.center =
      CGPointMake(self.buttonEight.center.x - 1,
                  self.buttonEight.center.y + scientificButtonsVerticalOffset);
  self.buttonCos.center =
      CGPointMake(self.buttonSin.center.x + scientificButtonsHorizontalOffset,
                  self.buttonSin.center.y);
  self.buttonTan.center =
      CGPointMake(self.buttonCos.center.x + scientificButtonsHorizontalOffset,
                  self.buttonCos.center.y);
  self.buttonCtg.center =
      CGPointMake(self.buttonTan.center.x + scientificButtonsHorizontalOffset,
                  self.buttonTan.center.y);

  self.inputLabel.center =
      CGPointMake(self.screenWidth / 2,
                  self.buttonTwo.center.y - self.screenHeight / 5.60504);
  self.algorithmChanger.center =
      CGPointMake(self.screenWidth / 2,
                  self.buttonSeven.center.y + self.screenHeight / 6.35238);
  self.turboLabelAndScSwitchView.center =
      CGPointMake(self.screenWidth / 2,
                  self.algorithmChanger.center.y + self.screenHeight / 15.881);
  self.dreamLabelAndStyleCh.center =
      CGPointMake(self.screenWidth / 2,
                  self.inputLabel.center.y - self.screenHeight / 10.5873);

  // Initializing some values
  self.countOfRightBrackets = 0;
  self.countOfLeftBrackets = 0;
  self.inputLabel.text = @"0";

  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                duration:(NSTimeInterval)duration {
  if ((orientation == UIInterfaceOrientationLandscapeLeft) ||
      (orientation == UIInterfaceOrientationLandscapeRight)) {
    self.buttonsCenterOffset = 0;
    NSInteger buttonsHorizontalOffset = 150;

    NSInteger temp;
    temp = self.screenHeight;
    self.screenHeight = self.screenWidth;
    self.screenWidth = temp;

    self.screenBound =
        CGRectMake(0, 0, self.screenWidth + buttonsHorizontalOffset * 2,
                   self.screenHeight);

    // Positioning equals button in the center of the view
    self.buttonEquals.center =
        CGPointMake(self.screenWidth / 2 + buttonsHorizontalOffset,
                    self.screenHeight / 2 +
                        self.buttonsCenterOffset);  // centering '=' button

    // Positioning inner circle buttons
    self.radius = 64.0;
    self.buttonPlus.center = CGPointMake(
        self.screenWidth / 2 + buttonsHorizontalOffset,
        self.screenHeight / 2 - self.radius +
            self.buttonsCenterOffset);  // centering '+' button relatively '='
    [self.uiDesignMethods positioningObjectsInCircle:self.innerCircleButtons
                                   andPreferedRadius:self.radius
                                     andScreenBounds:&(_screenBound)
                                   andVerticalOffset:self.buttonsCenterOffset];
    NSLog(@"Inner circle of buttons formed in landscape.\n\n");

    // Positioning outer circle buttons
    self.radius = 125.0;
    self.buttonTwo.center = CGPointMake(
        self.screenWidth / 2 + buttonsHorizontalOffset,
        self.screenHeight / 2 - self.radius +
            self.buttonsCenterOffset);  // centering '2' button relatively '='
    [self.uiDesignMethods positioningObjectsInCircle:self.outerCircleButtons
                                   andPreferedRadius:self.radius
                                     andScreenBounds:&(_screenBound)
                                   andVerticalOffset:self.buttonsCenterOffset];
    NSLog(@"Outer circle of buttons formed in landscape.\n\n");

    self.inputLabel.center = CGPointMake(self.buttonOne.center.x - 230,
                                         self.buttonOne.center.y - 15);
    self.dreamLabelAndStyleCh.center = CGPointMake(
        self.inputLabel.center.x,
        self.inputLabel.center.y - self.screenHeight / 10.5873 - 15);
    self.algorithmChanger.center =
        CGPointMake(self.inputLabel.center.x, self.buttonSeven.center.y - 15);
    self.turboLabelAndScSwitchView.center = CGPointMake(
        self.inputLabel.center.x,
        self.algorithmChanger.center.y + self.screenHeight / 15.881 + 15);

    // Positioning scientific buttons
    NSInteger scientificButtonsHorizontalOffset = 50;
    NSInteger scientificButtonsVerticalOffset = 81;
    self.buttonPower.center = CGPointMake(
        self.algorithmChanger.frame.origin.x + 20, self.buttonZero.center.y);
    self.buttonY.center = CGPointMake(
        self.buttonPower.center.x + scientificButtonsHorizontalOffset,
        self.buttonPower.center.y);
    self.buttonX.center =
        CGPointMake(self.buttonY.center.x + scientificButtonsHorizontalOffset,
                    self.buttonY.center.y);
    self.buttonSecondView.center =
        CGPointMake(self.buttonX.center.x + scientificButtonsHorizontalOffset,
                    self.buttonX.center.y);

    self.buttonSin.center = CGPointMake(
        self.buttonPower.center.x,
        self.buttonPower.center.y + scientificButtonsVerticalOffset);
    self.buttonCos.center =
        CGPointMake(self.buttonSin.center.x + scientificButtonsHorizontalOffset,
                    self.buttonSin.center.y);
    self.buttonTan.center =
        CGPointMake(self.buttonCos.center.x + scientificButtonsHorizontalOffset,
                    self.buttonCos.center.y);
    self.buttonCtg.center =
        CGPointMake(self.buttonTan.center.x + scientificButtonsHorizontalOffset,
                    self.buttonTan.center.y);

    temp = self.screenHeight;
    self.screenHeight = self.screenWidth;
    self.screenWidth = temp;
    self.screenBound = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
      

  } else {
    self.buttonsCenterOffset =
        self.screenHeight /
        26.68;  // to move button a bit down for a beeter reachebility

    // Positioning equals button in the center of the view
    self.buttonEquals.center =
        CGPointMake(self.screenWidth / 2,
                    self.screenHeight / 2 +
                        self.buttonsCenterOffset);  // centering '=' button

    // Positioning inner circle buttons
    self.radius = 64.0;
    self.buttonPlus.center = CGPointMake(
        self.screenWidth / 2,
        self.screenHeight / 2 - self.radius +
            self.buttonsCenterOffset);  // centering '+' button relatively '='
    [self.uiDesignMethods positioningObjectsInCircle:self.innerCircleButtons
                                   andPreferedRadius:self.radius
                                     andScreenBounds:&(_screenBound)
                                   andVerticalOffset:self.buttonsCenterOffset];
    NSLog(@"Inner circle of buttons formed.\n\n");

    // Positioning outer circle buttons
    self.radius = 125.0;
    self.buttonTwo.center = CGPointMake(
        self.screenWidth / 2,
        self.screenHeight / 2 - self.radius +
            self.buttonsCenterOffset);  // centering '2' button relatively '='
    [self.uiDesignMethods positioningObjectsInCircle:self.outerCircleButtons
                                   andPreferedRadius:self.radius
                                     andScreenBounds:&(_screenBound)
                                   andVerticalOffset:self.buttonsCenterOffset];
    NSLog(@"Outer circle of buttons formed.\n\n");

    // Positioning scientific buttons
    NSInteger scientificButtonsHorizontalOffset = 50;
    NSInteger scientificButtonsVerticalOffset = 81;
    self.buttonPower.center =
        CGPointMake(self.buttonOne.center.x - 1,
                    self.buttonOne.center.y - scientificButtonsVerticalOffset);
    self.buttonY.center = CGPointMake(
        self.buttonPower.center.x + scientificButtonsHorizontalOffset,
        self.buttonPower.center.y);
    self.buttonX.center =
        CGPointMake(self.buttonY.center.x + scientificButtonsHorizontalOffset,
                    self.buttonY.center.y);
    self.buttonSecondView.center =
        CGPointMake(self.buttonX.center.x + scientificButtonsHorizontalOffset,
                    self.buttonX.center.y);
    self.buttonSin.center = CGPointMake(
        self.buttonEight.center.x - 1,
        self.buttonEight.center.y + scientificButtonsVerticalOffset);
    self.buttonCos.center =
        CGPointMake(self.buttonSin.center.x + scientificButtonsHorizontalOffset,
                    self.buttonSin.center.y);
    self.buttonTan.center =
        CGPointMake(self.buttonCos.center.x + scientificButtonsHorizontalOffset,
                    self.buttonCos.center.y);
    self.buttonCtg.center =
        CGPointMake(self.buttonTan.center.x + scientificButtonsHorizontalOffset,
                    self.buttonTan.center.y);

    self.inputLabel.center =
        CGPointMake(self.screenWidth / 2,
                    self.buttonTwo.center.y - self.screenHeight / 5.60504);
    self.algorithmChanger.center =
        CGPointMake(self.screenWidth / 2,
                    self.buttonSeven.center.y + self.screenHeight / 6.35238);
    self.turboLabelAndScSwitchView.center =
        CGPointMake(self.screenWidth / 2, self.algorithmChanger.center.y +
                                              self.screenHeight / 15.881);
    self.dreamLabelAndStyleCh.center =
        CGPointMake(self.screenWidth / 2,
                    self.inputLabel.center.y - self.screenHeight / 10.5873);
  }
}

- (void)tapRecognizer:(UIGestureRecognizer*)sender {
  if ([self.inputLabel.text isEqualToString:@"0"] ||
      self.inputLabel.text.length == 1 ||
      [self.inputLabel.text containsString:@"y="] ||
      [self.inputLabel.text containsString:@"sin"] ||
      [self.inputLabel.text containsString:@"cos"] ||
      [self.inputLabel.text containsString:@"tan"] ||
      [self.inputLabel.text containsString:@"ctg"] ||
      [self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"] ||
      [self.inputLabel.text hasPrefix:@"n"] ||
      [self.inputLabel.text hasPrefix:@"i"]) {
    self.inputLabel.text = @"0";
    self.countOfLeftBrackets = 0;
    self.countOfRightBrackets = 0;
    self.isYPressed = NO;

  } else {
    NSString* tempSubString = [self.inputLabel.text
        substringToIndex:[self.inputLabel.text length] - 1];
    self.inputLabel.text = tempSubString;
  }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (IBAction)buttonEqualTouch:(id)sender {
  AudioServicesPlaySystemSound(1033);

  if (self.isYPressed) {
    self.inputLabel.text = @"Are you sure everything is ok?";
  } else {
    CalculatorModel* calcModel = [[CalculatorModel alloc] init];
    NSString* stringAfterRegex;

    if (self.countOfLeftBrackets != self.countOfRightBrackets) {
      self.inputLabel.text = @"Not enough brackets :(";
      self.countOfLeftBrackets = self.countOfRightBrackets = 0;
    } else {
      stringAfterRegex = [calcModel regexSyntaxCheker:self.inputLabel.text];
      if ([stringAfterRegex hasPrefix:@"A"]) {
        self.inputLabel.text = @"Are you sure everything is ok?";
      } else {
        NSString* parsedString =
            [calcModel parseUserInputFromLabel:stringAfterRegex];

        if (self.algorithmChanger.selectedSegmentIndex == 0) {
          NSLog(@"RPN ALGORITHM SELECTED");

          CGFloat result;
          result = [calcModel
              calculatingResultFromRPN:
                  [calcModel
                      reversePolishNotation:[calcModel
                                                prepareToRPN:parsedString]]];

          self.inputLabel.text = [NSString stringWithFormat:@"%g", result];

        } else if (self.algorithmChanger.selectedSegmentIndex == 1) {
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

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"1";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"1";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@1", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonTwoTouch:(id)sender {
  AudioServicesPlaySystemSound(1202);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"2";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"2";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@2", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonThreeTouch:(id)sender {
  AudioServicesPlaySystemSound(1203);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"3";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"3";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@3", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonFourTouch:(id)sender {
  AudioServicesPlaySystemSound(1204);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"4";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"4";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@4", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonFiveTouch:(id)sender {
  AudioServicesPlaySystemSound(1205);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"5";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"5";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@5", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonSixTouch:(id)sender {
  AudioServicesPlaySystemSound(1206);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"6";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"6";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@6", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonSevenTouch:(id)sender {
  AudioServicesPlaySystemSound(1207);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"7";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"7";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@7", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonEightTouch:(id)sender {
  AudioServicesPlaySystemSound(1208);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"8";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"8";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@8", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonNineTouch:(id)sender {
  AudioServicesPlaySystemSound(1209);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"9";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"9";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@9", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonZeroTouch:(id)sender {
  AudioServicesPlaySystemSound(1200);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"0";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"0";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@0", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonPlusTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"0";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"0+";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@+", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonMinusTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"0";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"0-";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@-", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonMultiplyTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"0";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"0*";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@*", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonDivideTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"0";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"0/";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@/", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonCommaTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"0";
  } else {
    self.inputLabel.text =
        [NSString stringWithFormat:@"%@.", self.inputLabel.text];
  }
}

- (IBAction)buttonClearTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  self.inputLabel.text = @"0";
  self.countOfLeftBrackets = 0;
  self.countOfRightBrackets = 0;
  self.isYPressed = NO;
}

- (IBAction)buttonRightBracketTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @")";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"0";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@)", self.inputLabel.text];
    }
  }

  self.countOfRightBrackets++;
}

- (IBAction)buttonLeftBracketTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"(";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"(";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@(", self.inputLabel.text];
    }
  }

  self.countOfLeftBrackets++;
}

- (IBAction)buttonSinTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"0";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"sin(";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@sin(", self.inputLabel.text];
    }

    self.countOfLeftBrackets++;
  }
}

- (IBAction)buttonCosTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"0";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"cos(";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@cos(", self.inputLabel.text];
    }

    self.countOfLeftBrackets++;
  }
}

- (IBAction)buttonTanTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"0";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"tan(";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@tan(", self.inputLabel.text];
    }

    self.countOfLeftBrackets++;
  }
}

- (IBAction)buttonCtgTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"0";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"ctg(";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@ctg(", self.inputLabel.text];
    }

    self.countOfLeftBrackets++;
  }
}

- (IBAction)buttonPowerTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"0";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"0^";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@^", self.inputLabel.text];
    }
  }
}

- (IBAction)buttonXTouch:(id)sender {
  AudioServicesPlaySystemSound(0x450);

  if ([self.inputLabel.text hasPrefix:@"N"] ||
      [self.inputLabel.text hasPrefix:@"A"]) {
    self.inputLabel.text = @"0";
  } else {
    if ([[NSString stringWithFormat:@"%@", self.inputLabel.text]
            isEqualToString:@"0"]) {
      self.inputLabel.text = @"0";
    } else {
      self.inputLabel.text =
          [NSString stringWithFormat:@"%@x", self.inputLabel.text];
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

  CATransition* transition = [CATransition animation];
  transition.duration = 0.20;
  transition.speed = 0.50;
  transition.timingFunction = [CAMediaTimingFunction
      functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.type = kCATransitionPush;
  transition.delegate = self;

  if ([self.scientificSwitch isOn]) {
    for (NSInteger i = 0; i < self.upperScientificFunctions.count; i++) {
      UIView* viewElement = [self.upperScientificFunctions objectAtIndex:i];
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

  } else {
    for (NSInteger i = 0; i < self.upperScientificFunctions.count; i++) {
      UIView* viewElement = [self.upperScientificFunctions objectAtIndex:i];
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

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
  if (self.countOfLeftBrackets != self.countOfRightBrackets) {
    self.countOfLeftBrackets = self.countOfRightBrackets = 0;

    if ([segue.identifier isEqualToString:@"goToPlotViewSegue"]) {
      SecondViewController* seconViewController =
          (SecondViewController*)segue.destinationViewController;

      seconViewController.labelTextFromFirstView =
          @"Are you sure everything is ok?";
    }

  } else {
    if ([segue.identifier isEqualToString:@"goToPlotViewSegue"]) {
      SecondViewController* seconViewController =
          (SecondViewController*)segue.destinationViewController;

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

  NSString* functionToTabulate = @"";

  for (NSInteger i = 2; i < self.inputLabel.text.length; i++) {
    functionToTabulate =
        [NSString stringWithFormat:@"%@%c", functionToTabulate,
                                   [self.inputLabel.text characterAtIndex:i]];
  }

  // Tabulating params
  NSInteger a = -10;
  NSInteger b = 10;
  CGFloat step = 0.5;

  [calcModel functionTabulator:functionToTabulate
                      andRange:a
                        andEnd:b
                       andStep:step];

  self.transferingDataX = calcModel.tabulatedXdata;
  self.transferingDataY = calcModel.tabulatedYdata;
}

- (IBAction)styleChanger:(id)sender {
  AudioServicesPlaySystemSound(1057);

  if (self.styleChangeButtonPressed == YES) {
    UIImage* myBackgroundImage = [UIImage imageNamed:@"galaxy.jpg"];
    // UIImage *myBackgroundImageBlurred = [self.uiDesignMethods
    // blurWithCoreImage: myBackgroundImage andUIView: self.view];
    self.view.backgroundColor =
        [UIColor colorWithPatternImage:myBackgroundImage];
    NSLog(@"Blured background set!\n\n");

    [self.uiDesignMethods animationsMaker:self.view duration:0.20 speed:0.50];

    self.styleChangeButtonPressed = NO;

  } else {
    UIImage* myBackgroundImage = [UIImage imageNamed:@"wood1.png"];
    // UIImage *myBackgroundImageBlurred = [self.uiDesignMethods
    // blurWithCoreImage: myBackgroundImage andUIView: self.view];
    self.view.backgroundColor =
        [UIColor colorWithPatternImage:myBackgroundImage];
    NSLog(@"Blured background set!\n\n");

    [self.uiDesignMethods animationsMaker:self.view duration:0.20 speed:0.50];

    self.styleChangeButtonPressed = YES;
  }
}

@end
