//
//  Themes.m
//  FintechChat
//
//  Created by Ирина Улитина on 02/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Themes.h"


@implementation Themes


- (UIColor *)theme1
{
    return self->theme1;
}

- (UIColor *)theme2
{
    return self->theme2;
}

- (UIColor *)theme3
{
    return self->theme3;
}

- (void)setTheme1:(UIColor *)newColor
{
    [newColor retain];
    [self->theme1 release];
    self->theme1 = newColor;
}

- (void)setTheme2:(UIColor *)newColor
{
    [newColor retain];
    [self->theme2 release];
    self->theme2 = newColor;
}

- (void)setTheme3:(UIColor *)newColor
{
    [newColor retain];
    [self->theme3 release];
    self->theme3 = newColor;
}

- (id)initWithColors:(UIColor *)theme1Color c1:(UIColor *)theme2Color c2:(UIColor *)theme3Color
{
    self = [self init];

    [self setTheme1:theme1Color];
    [self setTheme2:theme2Color];
    [self setTheme3:theme3Color];

    return self;
}

- (void)dealloc
{
    [theme1 release];
    [theme2 release];
    [theme3 release];
    [super dealloc];
}
@end
