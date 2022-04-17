//
//  DEMONavigationController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMONavigationController.h"


@interface DEMONavigationController ()

@end

@implementation DEMONavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
   
     
    if([self.visibleViewController.restorationIdentifier isEqualToString:@"HomeVCSID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"MyJobsVCSID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"BankingDetailVCSID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"MYProfileVCSID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"ChangePasswordVCSID"]){
        [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
        
        // Present the view controller
        //
        [self.frostedViewController panGestureRecognized:sender];
        
    }
    
}

@end
