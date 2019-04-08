//
//  ThemesViewController.m
//  FintechChat
//
//  Created by Ирина Улитина on 02/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemesViewController.h"


@implementation ThemesViewController


- (void)setDelegate:(id<ThemesViewControllerDelegate>)newDelegate
{
    if (delegate != newDelegate) {
        [newDelegate retain];
        [self->delegate release];
        self->delegate = newDelegate;
    }
}
- (id<ThemesViewControllerDelegate>)delegate
{
    return self->delegate;
}

- (Themes *)model
{
    return self->model;
}

- (void)setModel:(Themes *)newModel
{
    [self->model release];
    self->model = newModel;
}

-(void) styleButton: (UIButton *)currButton button: (int) themeNum
{
    [currButton setTitle:[NSString stringWithFormat:@"Тема %d", themeNum]  forState: normal];
    [[currButton layer] setCornerRadius : 10];
    [currButton setBackgroundColor: [[[UIColor alloc] initWithRed:255.0 / 255.0 green:250.0 / 255.0 blue:205.0 / 255.0 alpha:1.0] autorelease]];
    [currButton setTitleColor:[UIColor blackColor] forState:normal];
    [[currButton layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[currButton layer] setBorderWidth:1];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    [self setModel:[[Themes alloc] initWithColors:[[[UIColor alloc] initWithRed:32.0/255 green:32.0/255 blue:32.0/255 alpha:1] autorelease] c1:[[[UIColor alloc] initWithRed:247.0 / 255.0 green:231.0 / 255.0 blue:206.0 / 255.0 alpha:1.0] autorelease] c2:[[UIColor whiteColor] autorelease]]];
    
    navBarView = [[UIView alloc] init];
    [navBarView setBackgroundColor:[[[UIColor alloc] initWithRed:0.8 green:0.8 blue:0.8 alpha:0.6] autorelease]];
    [navBarView setTranslatesAutoresizingMaskIntoConstraints:false];
    closeButton = [[UIButton alloc] init];
    [closeButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [closeButton setTitle:@"Закрыть" forState:normal];
    [closeButton setTitleColor:[UIColor blueColor] forState:normal];
    [navBarView addSubview:closeButton];
    [[[closeButton rightAnchor] constraintEqualToAnchor:[navBarView rightAnchor] constant:-16] setActive:true];
    [[[closeButton bottomAnchor] constraintEqualToAnchor:[navBarView bottomAnchor] constant:-12] setActive:true];
    [closeButton addTarget:self action:@selector(closeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self view] addSubview:navBarView];
    
    [[[navBarView topAnchor] constraintEqualToAnchor:[[self view] topAnchor] constant:0] setActive:true];
    [[[navBarView leftAnchor] constraintEqualToAnchor:[[self view] leftAnchor] constant:0] setActive:true];
    [[[navBarView rightAnchor] constraintEqualToAnchor:[[self view] rightAnchor] constant:0] setActive:true];
    
    [[[navBarView heightAnchor] constraintEqualToAnchor:[[self view] heightAnchor] multiplier:1.0 / 9.0] setActive:true];
    

    [[self view] setBackgroundColor:[UIColor yellowColor]];
    theme1Button = [[UIButton alloc] init];
    theme2Button = [[UIButton alloc] init];
    theme3Button = [[UIButton alloc] init];
    [self styleButton:theme1Button button:1];
    [self styleButton:theme2Button button:2];
    [self styleButton:theme3Button button:3];

    
    
    //[theme1Button addTarget:self action:#selector(setThemeButtonOnClick) forControlEvents:UIControlEventTouchUpInside]
    
    [theme1Button addTarget:self action:@selector(setTheme1ButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [theme2Button addTarget:self action:@selector(setTheme2ButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [theme3Button addTarget:self action:@selector(setTheme3ButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *helperView = [[UIView alloc] init];
    UIView *helperView2 = [[UIView alloc] init];
    containerStackView = [[UIStackView alloc] initWithArrangedSubviews:([[[NSArray alloc] initWithObjects:theme1Button, helperView, theme2Button, helperView2, theme3Button, nil] autorelease])];
    
    [helperView release];
    [helperView2 release];
    
    [[self view] addSubview:containerStackView];
    [containerStackView setTranslatesAutoresizingMaskIntoConstraints:false];
    [containerStackView setAxis:UILayoutConstraintAxisVertical];
    [containerStackView setDistribution:UIStackViewDistributionFillEqually];
    
    [[[containerStackView centerXAnchor] constraintEqualToAnchor:[[self view] centerXAnchor]] setActive:true];
    
    [[[containerStackView centerYAnchor] constraintEqualToAnchor:[[self view] centerYAnchor]] setActive:true];
    
    [[[containerStackView heightAnchor] constraintEqualToAnchor:[[self view] heightAnchor] multiplier:0.4] setActive:true];
    
    [[[containerStackView widthAnchor] constraintEqualToAnchor:[[self view] widthAnchor] multiplier:0.5] setActive:true];
    //[containerStackView release];
}

-(void) closeButtonOnClick: (NSObject*) sender
{
    [self dismissViewControllerAnimated:true completion:^{
        //NSLog(@"%d", [[self model] retainCount]);
    }];
}

-(void) setTheme1ButtonOnClick: (NSObject*) sender
{
    [[self view] setBackgroundColor:[model theme1]];
    [[self delegate] themesViewController:self didSelectTheme:[model theme1]];
}

-(void) setTheme2ButtonOnClick: (NSObject*) sender
{
    [[self view] setBackgroundColor:[model theme2]];
    [[self delegate] themesViewController:self didSelectTheme:[model theme2]];
}

-(void) setTheme3ButtonOnClick: (NSObject*) sender
{
    [[self view] setBackgroundColor:[model theme3]];
    [[self delegate] themesViewController:self didSelectTheme:[model theme3]];

}

- (void)dealloc
{
    [self->navBarView release];
    [self->theme3Button release];
    [self->theme2Button release];
    [self->theme1Button release];
    [self->containerStackView release];
    
    [self->closeButton release];

    [self->model release];
    [super dealloc];
}

@end
