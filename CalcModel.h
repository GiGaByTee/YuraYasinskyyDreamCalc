//
//  CalcModel.h
//  dreamCalc
//
//  Created by Yura Yasinskyy on 17.06.16.
//  Copyright © 2016 Yura Yasinskyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcModel : NSObject

- (NSNumber*) resultWithNSExpression: (NSString*) inputString;

- (NSMutableArray*) prepareToBackPolishing: (NSString*) inputString;

- (NSMutableArray*) backPolishing: (NSMutableArray*) preparedArray;

- (double) calculatingResult: (NSMutableArray*) backPolishNotation;



@end
