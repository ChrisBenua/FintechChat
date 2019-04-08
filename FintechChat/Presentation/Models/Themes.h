//
//  Themes.h
//  FintechChat
//
//  Created by Ирина Улитина on 02/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

#ifndef Themes_h
#define Themes_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Themes : NSObject
{
    UIColor *theme1;
    UIColor *theme2;
    UIColor *theme3;
}

-(UIColor*) theme1;

-(UIColor*) theme2;

-(UIColor*) theme3;

-(void) setTheme1: (UIColor*) newColor;

-(void) setTheme2: (UIColor*) newColor;

-(void) setTheme3: (UIColor*) newColor;

-(id) initWithColors: (UIColor*) theme1Color c1: (UIColor*) theme2Color c2: (UIColor*) theme3Color;

@end

#endif /* Themes_h */
