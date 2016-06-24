//
//  CalcModel.m
//  dreamCalc
//
//  Created by Yura Yasinskyy on 17.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import "CalcModel.h"

@implementation CalcModel


- (NSNumber*) resultWithNSExpression: (NSString*) inputString {
    
    NSString *numericExpression = inputString;
    
    NSExpression *expression = [NSExpression expressionWithFormat:numericExpression];
    NSNumber *result = [expression expressionValueWithObject:nil context:nil];
    
    return result;
}


- (NSMutableArray*) prepareToBackPolishing: (NSString*) inputString {
    //separating numbers and operators drom input string and putting them into NSMutableArray
    
    NSString* s1 = inputString; //input string that will be proccessed
    //s1 = @"7.0 + ( 5 - 2 ) * 4";
    s1 = [NSString stringWithFormat:@"%@ ", s1];
    NSMutableArray *preparedToPolishing = [[NSMutableArray alloc] init];
    NSString* temp = @"";
    
    char element;
    
    for (int i = 0; i < s1.length; i++) {
        
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
    
    NSMutableArray *preparedToPolishing = [[NSMutableArray alloc] init];
    preparedToPolishing = preparedArray;
    
    NSMutableArray *backPolished = [[NSMutableArray alloc] init]; //output string
    NSMutableArray *helpString = [[NSMutableArray alloc] init]; //stack
    
    double numberFromPrepared;
    NSString* tempString;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    [numberFormatter setDecimalSeparator:@"."];
    
    
    for (int i = 0; i < preparedToPolishing.count; i++) {
        
        tempString = [NSString stringWithFormat:@"%@", [preparedToPolishing objectAtIndex: i]];
        NSLog(@"temp string value: %@", tempString);
        
        
        
        NSNumber *numberFromString = [numberFormatter numberFromString: tempString];
        numberFromPrepared = [numberFromString doubleValue];
        //NSLog(@"%f", numberFromPrepared);
        
        if (numberFromPrepared == 0) {
            
            if ([tempString isEqualToString: @"*"]) {
                
                [helpString addObject: tempString];
                NSLog(@"* recognized");
            }
            else if ([tempString isEqualToString: @"/"])
            {
                
                [helpString addObject: tempString];
                NSLog(@"/ recognized");
            }
            else if ([tempString isEqualToString: @"+"])
            {
                while ([helpString.lastObject isEqual:@"*"] || [helpString.lastObject isEqual:@"/"] || [helpString.lastObject isEqual:@"+"] || [helpString.lastObject isEqual:@"-"]) {
                    
                    [backPolished addObject: helpString.lastObject];
                    [helpString removeLastObject];
                }
                [helpString addObject: tempString];
                NSLog(@"+ recognized");
            }
            else if ([tempString isEqualToString: @"-"])
            {
                while ([helpString.lastObject isEqual:@"*"] || [helpString.lastObject isEqual:@"/"] || [helpString.lastObject isEqual:@"+"] || [helpString.lastObject isEqual:@"-"]) {
                    
                    [backPolished addObject: helpString.lastObject];
                    [helpString removeLastObject];
                }
                [helpString addObject: tempString];
                NSLog(@"- recognized");
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
    
    
    /* for (int i = 0; i < backPolished.count; i++) {
     
     NSLog(@"%@", [backPolished objectAtIndex: i]);
     }  just to check */
    
    return backPolished;
}

- (double) calculatingResult: (NSMutableArray*) backPolishNotation {
    
    
    NSMutableArray *backPolished = [[NSMutableArray alloc] init];
    backPolished = backPolishNotation;
    
    NSMutableArray *resultStack = [[NSMutableArray alloc] init];
    double tempNumber;
    double result;
    

    for (int i = 0; i < backPolished.count; i++) {
        
        if ([[backPolished objectAtIndex: i] isEqual:@"+"]) {
            
            tempNumber = [[resultStack objectAtIndex: (resultStack.count-1)] doubleValue] + [[resultStack objectAtIndex: (resultStack.count-2)] doubleValue];
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
        } else {
            
            [resultStack addObject:[backPolished objectAtIndex: i]];
            
        }
        
        
    } //end of for loop
    
    
    result = [[resultStack objectAtIndex:0] doubleValue];
    NSLog(@"the result is: %f", result);
    
    return result;
}





@end
