//
//  ThemesViewController.h
//  FintechChat
//
//  Created by Ирина Улитина on 02/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

#ifndef ThemesViewController_h
#define ThemesViewController_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ThemesViewControllerDelegate.h"
#import "Themes.h"

@interface ThemesViewController : UIViewController
{
    UIButton *theme1Button;
    
    UIButton *theme2Button;
    
    UIButton *theme3Button;
    
    Themes *model;
    
    id<ThemesViewControllerDelegate> delegate;
    
    UIView *navBarView;
    
    UIStackView *containerStackView;
    
    UIButton *closeButton;
    
}

-(Themes *) model;

-(void) setModel: (Themes*) newModel;

-(void) setDelegate: (id<ThemesViewControllerDelegate>) newDelegate;

-(id<ThemesViewControllerDelegate>) delegate;

@end


#endif /* ThemesViewController_h */
