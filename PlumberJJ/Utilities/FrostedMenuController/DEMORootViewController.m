//
//  DEMOViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMORootViewController.h"
//#import "RZTransitionsInteractionControllers.h"
//#import "RZTransitionsAnimationControllers.h"
//#import "RZTransitionInteractionControllerProtocol.h"
//#import "RZTransitionsManager.h"

@interface DEMORootViewController ()

//@property (nonatomic, strong) id<RZTransitionInteractionController> pushPopInteractionController;
//@property (nonatomic, strong) id<RZTransitionInteractionController> presentInteractionController;
//@property (nonatomic, strong) id<RZTransitionInteractionController> pinchInteractionController;


@end

@implementation DEMORootViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StarterNavVCSID"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    // Create the push and pop interaction controller that allows a custom gesture
//    // to control pushing and popping from the navigation controller
//    self.pushPopInteractionController = [[RZHorizontalInteractionController alloc] init];
//    [self.pushPopInteractionController setNextViewControllerDelegate:self];
//    [self.pushPopInteractionController attachViewController:self withAction:RZTransitionAction_PushPop];
//    [[RZTransitionsManager shared] setInteractionController:self.pushPopInteractionController
//                                         fromViewController:[self class]
//                                           toViewController:nil
//                                                  forAction:RZTransitionAction_PushPop];
//
//
//    // Create the presentation interaction controller that allows a custom gesture
//    // to control presenting a new VC via a presentViewController
//    self.presentInteractionController = [[RZVerticalSwipeInteractionController alloc] init];
//    [self.presentInteractionController setNextViewControllerDelegate:self];
//    [self.presentInteractionController attachViewController:self withAction:RZTransitionAction_Present];
//
//    self.pinchInteractionController = [RZPinchInteractionController new];
//    [self.pinchInteractionController setNextViewControllerDelegate:self];
//    [self.pinchInteractionController attachViewController:self withAction:RZTransitionAction_Present];
//
//    // Setup the push & pop animations as well as a special animation for pushing a
//    // RZSimpleCollectionViewController
//    [[RZTransitionsManager shared] setAnimationController:[[RZCardSlideAnimationController alloc] init]
//                                       fromViewController:[self class]
//                                                forAction:RZTransitionAction_PushPop];
//
//    // Setup the animations for presenting and dismissing a new VC
//    [[RZTransitionsManager shared] setAnimationController:[[RZCirclePushAnimationController alloc] init]
//                                       fromViewController:[self class]
//                                                forAction:RZTransitionAction_PresentDismiss];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [[RZTransitionsManager shared] setInteractionController:self.presentInteractionController
//                                         fromViewController:[self class]
//                                           toViewController:nil
//                                                  forAction:RZTransitionAction_Present];
//    [[RZTransitionsManager shared] setInteractionController:self.pinchInteractionController
//                                         fromViewController:[self class]
//                                           toViewController:nil
//                                                  forAction:RZTransitionAction_Present];
//}

@end
