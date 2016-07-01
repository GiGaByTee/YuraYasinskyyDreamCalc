//
//  CalcModel.m
//  dreamCalc
//
//  Created by Yura Yasinskyy on 17.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import "CalcModel.h"

@implementation CalcModel

@synthesize tabulatedXdata, tabulatedYdata;


- (NSString*) regexSyntaxCheker: (NSString*) inputText {
    
    NSString* myEquation = inputText;
    
    NSString* pattern = @"(?:\\*|\\/|\\+|\\-|\\.|\\^)[\\*\\/\\+\\-\\.\\^]|\\([\\)\\*\\/\\+\\-\\.\\^]|(?:\\*|\\/|\\+|\\-|\\.\\^)[\\)]|\\)[\\.\\(]|\\d{1,10}\\.\\d{1,10}\\.|\\(\\d{1,10}\\)|\\d{1,10}\\/0{1,10}\\d{1,10}|[\\*\\/\\+\\-\\.\\^]$";
    
    
    NSError* regexError = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&regexError];
    
    if (regexError)
    {
        NSLog(@"Regex creation failed with error: %@", [regexError description]);
        return @"Sorry, something's wrong with regex :(";
    }
    
    NSArray* matches = [regex matchesInString: myEquation options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, myEquation.length)];
    if (matches.count != 0) {
        
        NSLog(@"REGEX: matches found!");
        return @"Are you sure everything is ok?";
    }
    else {
        
        NSLog(@"REGEX: found no matches!");
        return myEquation;
    }
    
}


//String should be without y= like this: y=x -> x
- (void) functionTabulator: (NSString*) inputStringFunction andRange: (NSInteger) rangeStart andEnd: (NSInteger) rangeEnd  andStep: (CGFloat) tabulationStep {
    
    NSString * newString;
    //NSString * stringAfterParsing;
    NSNumber * yResultforX;
    CGFloat step = tabulationStep;
    
    tabulatedXdata = [[NSMutableArray alloc] init];
    tabulatedYdata = [[NSMutableArray alloc] init];
    
    
    NSLog(@"Function y=%@ is tabulated with data:", inputStringFunction);
    
    for (CGFloat i = rangeStart; i <= rangeEnd; i+=step) {
        
        newString = [inputStringFunction stringByReplacingOccurrencesOfString:@"x" withString:[NSString stringWithFormat:@"%g", i]];
        
        
        [tabulatedXdata addObject:[NSNumber numberWithDouble:i]]; // x values
        
        //yResultforX = [self resultWithNSExpression: newString];
        
        
        NSMutableArray* arr1;
        arr1 = [self prepareToBackPolishing: newString];
        
        NSMutableArray* arr2;
        arr2 = [self backPolishing: arr1];
        
        CGFloat result;
        result = [self calculatingResult: arr2];
        
        yResultforX = [NSNumber numberWithDouble:result]; // y values
        
        [tabulatedYdata addObject:yResultforX];
        
        
        NSLog(@"x: %g y: %g", i, [yResultforX doubleValue]);
        
    }
    
    
    
    
    
    
    
    
}

- (NSString*) parseUserInputFromLabel: (NSString*) text {
    
    NSString* labelInput;
    NSString* parsedString = @"";
    char element;
    
    //labelInput = @"77.0+(55-2)*4"; //after parsing should be 77.0 + ( 55 - 2 ) * 4
    labelInput = text;
    NSLog(@"text from input %@", labelInput);
    
    
    for (NSInteger i = 0; i < labelInput.length; i++) {
        
        element = [labelInput characterAtIndex: i];
        
        if ([[NSString stringWithFormat:@"%c", element]  isEqual: @"("] || [[NSString stringWithFormat:@"%c", element]  isEqual: @")"] || [[NSString stringWithFormat:@"%c", element]  isEqual: @"+"] || [[NSString stringWithFormat:@"%c", element]  isEqual: @"-"] || [[NSString stringWithFormat:@"%c", element]  isEqual: @"*"] || [[NSString stringWithFormat:@"%c", element]  isEqual: @"/"] || [[NSString stringWithFormat:@"%c", element]  isEqual: @"^"]) {
            
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
                if ([[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"("] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@")"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"+"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"-"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"*"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"/"] || [[NSString stringWithFormat:@"%c",[labelInput characterAtIndex: i-1]] isEqual:@"^"]) {
                    
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

- (NSNumber*) resultWithNSExpression: (NSString*) inputString {
    
    NSString *numericExpression = inputString;
    
    NSExpression *expression = [NSExpression expressionWithFormat:numericExpression];
    NSNumber *result = [expression expressionValueWithObject:nil context:nil];
    
    return result;
}


- (NSMutableArray*) prepareToBackPolishing: (NSString*) inputString {
    //separating numbers and operators from input string and putting them into NSMutableArray
    
    NSString* s1 = inputString; //input string that will be proccessed
    //s1 = @"7.0 + ( 5 - 2 ) * 4";
    s1 = [NSString stringWithFormat:@"%@ ", s1];
    NSMutableArray *preparedToPolishing = [[NSMutableArray alloc] init];
    NSString* temp = @"";
    
    char element;
    
    for (NSInteger i = 0; i < s1.length; i++) {
        
        element = [s1 characterAtIndex: i];
        if ([[NSString stringWithFormat:@"%c", element]  isEqual: @" "]) {
            
            [preparedToPolishing addObject: temp];
            temp = @"";
            //NSLog(@"%@", [preparedToPolishing objectAtIndex: 0]);
            continue;
        }
        else {
            
            temp = [NSString stringWithFormat:@"%@%c", temp, element];
        }
        
        //NSLog(@"%@", temp);
    }
    
    return preparedToPolishing;
}

- (NSMutableArray*) backPolishing: (NSMutableArray*) preparedArray {
    
    NSMutableArray *preparedToPolishing;
    preparedToPolishing = preparedArray;
    
    NSMutableArray *backPolished = [[NSMutableArray alloc] init]; //output string
    NSMutableArray *helpString = [[NSMutableArray alloc] init]; //stack
    
    CGFloat numberFromPrepared;
    NSString* tempString;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    [numberFormatter setDecimalSeparator:@"."];
    
    
    for (NSInteger i = 0; i < preparedToPolishing.count; i++) {
        
        tempString = [NSString stringWithFormat:@"%@", [preparedToPolishing objectAtIndex: i]];
        NSLog(@"temp string value: %@", tempString);
        
        NSNumber *numberFromString = [numberFormatter numberFromString: tempString];
        numberFromPrepared = [numberFromString doubleValue];
        //NSLog(@"%f", numberFromPrepared);
        
        if (numberFromPrepared == 0) {
            
            if ([tempString isEqualToString: @"^"]) {
                
                while ([helpString.lastObject isEqual:@"^"]) {
                    
                    [backPolished addObject: helpString.lastObject];
                    [helpString removeLastObject];
                }
                
                [helpString addObject: tempString];
                NSLog(@"^ recognized");
            }
            else
            
            if ([tempString isEqualToString: @"*"]) {
                
                while ([helpString.lastObject isEqual:@"*"] || [helpString.lastObject isEqual:@"/"] || [helpString.lastObject isEqual:@"^"]) {
                    
                    [backPolished addObject: helpString.lastObject];
                    [helpString removeLastObject];
                }
                
                [helpString addObject: tempString];
                NSLog(@"* recognized");
            }
            else if ([tempString isEqualToString: @"/"])
            {
                
                while ([helpString.lastObject isEqual:@"*"] || [helpString.lastObject isEqual:@"/"] || [helpString.lastObject isEqual:@"^"]) {
                    
                    [backPolished addObject: helpString.lastObject];
                    [helpString removeLastObject];
                }
                
                [helpString addObject: tempString];
                NSLog(@"/ recognized");
            }
            else if ([tempString isEqualToString: @"+"])
            {
                while ([helpString.lastObject isEqual:@"*"] || [helpString.lastObject isEqual:@"/"] || [helpString.lastObject isEqual:@"+"] || [helpString.lastObject isEqual:@"-"] || [helpString.lastObject isEqual:@"sin"] || [helpString.lastObject isEqual:@"cos"]|| [helpString.lastObject isEqual:@"tan"] || [helpString.lastObject isEqual:@"ctg"] || [helpString.lastObject isEqual:@"^"]) {
                    
                    [backPolished addObject: helpString.lastObject];
                    [helpString removeLastObject];
                }
                [helpString addObject: tempString];
                NSLog(@"+ recognized");
            }
            else if ([tempString isEqualToString: @"-"])
            {
                while ([helpString.lastObject isEqual:@"*"] || [helpString.lastObject isEqual:@"/"] || [helpString.lastObject isEqual:@"+"] || [helpString.lastObject isEqual:@"-"] || [helpString.lastObject isEqual:@"sin"] || [helpString.lastObject isEqual:@"cos"]|| [helpString.lastObject isEqual:@"tan"] || [helpString.lastObject isEqual:@"ctg"] || [helpString.lastObject isEqual:@"^"]) {
                    
                    [backPolished addObject: helpString.lastObject];
                    [helpString removeLastObject];
                }
                [helpString addObject: tempString];
                NSLog(@"- recognized");
            }
            else if ([tempString isEqualToString: @"sin"])
            {
                
                
                [helpString addObject:@"sin"];
                NSLog(@"sin recognized");
            }
            else if ([tempString isEqualToString: @"cos"])
            {
                
                
                [helpString addObject:@"cos"];
                NSLog(@"sin recognized");
            }
            else if ([tempString isEqualToString: @"tan"])
            {
                
                
                [helpString addObject:@"tan"];
                NSLog(@"sin recognized");
            }
            else if ([tempString isEqualToString: @"ctg"])
            {
                
                
                [helpString addObject:@"ctg"];
                NSLog(@"sin recognized");
            }
            else if ([tempString isEqualToString: @"("])
            {
                
                [helpString addObject: tempString];
                NSLog(@"( recognized");
            }
            else if ([tempString isEqualToString: @")"])
            {
                while (![helpString.lastObject isEqual:@"("]) {
                    
                    [backPolished addObject: helpString.lastObject];
                    [helpString removeLastObject];
                }
                [helpString removeLastObject];
                NSLog(@") recognized");
                
            }
            else {
                
                [backPolished addObject: [NSNumber numberWithDouble: 0]];
                //NSLog(@"number recognized: %f", numberFromPrepared);
            }
            
            
            
        }
        else {
            
            [backPolished addObject: [NSNumber numberWithDouble: numberFromPrepared]];
            NSLog(@"number recognized: %f", numberFromPrepared);
        }
        
        
    } //end of for loop
    while (helpString.count != 0) {
        
        [backPolished addObject: helpString.lastObject];
        [helpString removeLastObject];
    }
    
    
    /* for (NSInteger i = 0; i < backPolished.count; i++) {
     
     NSLog(@"%@", [backPolished objectAtIndex: i]);
     }  just to check */
    
    return backPolished;
}

- (CGFloat) calculatingResult: (NSMutableArray*) backPolishNotation {
    
    
    NSMutableArray *backPolished;
    backPolished = backPolishNotation;
    
    NSMutableArray *resultStack = [[NSMutableArray alloc] init];
    CGFloat tempNumber;
    CGFloat result;
    
    
    for (NSInteger i = 0; i < backPolished.count; i++) {
        
        if ([[backPolished objectAtIndex: i] isEqual:@"^"]) {
            
            
            tempNumber = pow([[resultStack objectAtIndex: (resultStack.count-2)] doubleValue], [[resultStack objectAtIndex: (resultStack.count-1)] doubleValue]);
            [resultStack removeLastObject];
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
            
        } else if ([[backPolished objectAtIndex: i] isEqual:@"+"]) {
            
            tempNumber = [[resultStack objectAtIndex: resultStack.count-1] doubleValue] + [[resultStack objectAtIndex: resultStack.count-2] doubleValue];
            [resultStack removeLastObject];
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
            
        } else if ([[backPolished objectAtIndex: i] isEqual:@"-"]) {
            
            tempNumber = [[resultStack objectAtIndex: (resultStack.count-2)] doubleValue] - [[resultStack objectAtIndex: (resultStack.count-1)] doubleValue];
            [resultStack removeLastObject];
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
        } else if ([[backPolished objectAtIndex: i] isEqual:@"*"]) {
            
            tempNumber = [[resultStack objectAtIndex: (resultStack.count-1)] doubleValue] * [[resultStack objectAtIndex: (resultStack.count-2)] doubleValue];
            [resultStack removeLastObject];
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
        } else if ([[backPolished objectAtIndex: i] isEqual:@"/"]) {
            
            tempNumber = [[resultStack objectAtIndex: (resultStack.count-2)] doubleValue] / [[resultStack objectAtIndex: (resultStack.count-1)] doubleValue];
            [resultStack removeLastObject];
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
        } else if ([[backPolished objectAtIndex: i] isEqual:@"sin"]) {
            
            tempNumber = sin([[resultStack objectAtIndex: (resultStack.count-1)] doubleValue]);
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
        } else if ([[backPolished objectAtIndex: i] isEqual:@"cos"]) {
            
            tempNumber = cos([[resultStack objectAtIndex: (resultStack.count-1)] doubleValue]);
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
        } else if ([[backPolished objectAtIndex: i] isEqual:@"tan"]) {
            
            tempNumber = tan([[resultStack objectAtIndex: (resultStack.count-1)] doubleValue]);
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
        } else if ([[backPolished objectAtIndex: i] isEqual:@"ctg"]) {
            
            tempNumber = pow(tan(([[resultStack objectAtIndex: (resultStack.count-1)] doubleValue])), -1);
            [resultStack removeLastObject];
            [resultStack addObject: [NSNumber numberWithDouble:tempNumber]];
        }
        else {
            
            [resultStack addObject:[backPolished objectAtIndex: i]];
            
        }
        
    } //end of for loop

    
    result = [[resultStack objectAtIndex:0] doubleValue];
    NSLog(@"the result is: %f", result);
    
    return result;
}





@end
