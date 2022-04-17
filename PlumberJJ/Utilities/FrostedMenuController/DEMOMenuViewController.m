//
//  DEMOMenuViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//
#import "DEMOMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "DEMONavigationController.h"
#import "MenuTableViewCell.h"
//#import <PlumberJJ-Swift.h>
#import <Hive_Pro-Swift.h>

//#import "SDWebImage-Swift.h"

#import "Canvas.h"
@import SDWebImage;

@interface DEMOMenuViewController (){
    Theme * objTheme;
    SocketIOManager *connectSocket;
      Languagehandler * objLanguagehandler;
    
    
}

@end

@implementation DEMOMenuViewController
@synthesize titleArray;
@synthesize ImgArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    objTheme=[[Theme alloc]init];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogoutMethod1:) name:@"Logout" object:nil];
 
}

-(void) viewWillAppear:(BOOL)animated
{
       objLanguagehandler=[[Languagehandler alloc]init];

    [titleArray removeAllObjects];
    [ImgArray removeAllObjects];
    NSLog(@"The Them Document Status is====> %@",objTheme.getDocumentStatus);
    if (objTheme.isLanguageManagement == 0){
        if ([objTheme.getDocumentStatus isEqual: @"0"]){
            titleArray=[[NSMutableArray alloc]initWithObjects:[objLanguagehandler VJLocalizedString:@"home" comment:nil],[objLanguagehandler VJLocalizedString:@"my_jobs" comment:nil],/*[objLanguagehandler VJLocalizedString:@"transactions" comment:nil],[objLanguagehandler VJLocalizedString:@"notifications" comment:nil],[objLanguagehandler VJLocalizedString:@"reviews" comment:nil],[objLanguagehandler VJLocalizedString:@"change_password" comment:nil],*/[objLanguagehandler VJLocalizedString:@"my_earnings" comment:nil],/*[objLanguagehandler VJLocalizedString:@"chat" comment:nil],*/[objLanguagehandler VJLocalizedString:@"banking_details" comment:nil], [objLanguagehandler VJLocalizedString:@"about" comment:nil],[objLanguagehandler VJLocalizedString:@"logout" comment:nil],nil];
            
            ImgArray=[[NSMutableArray alloc]initWithObjects:@"MenuHome",@"MenuOrders"/*,@"Transaction",@"notification",@"review",@"MenuProfile"*/,@"menu_earnings",/*@"ChatImg",*/@"MenuBanking",@"About-30",@"logout" ,nil];
        }else{
            titleArray=[[NSMutableArray alloc]initWithObjects:[objLanguagehandler VJLocalizedString:@"home" comment:nil],[objLanguagehandler VJLocalizedString:@"my_jobs" comment:nil],/*[objLanguagehandler VJLocalizedString:@"transactions" comment:nil],[objLanguagehandler VJLocalizedString:@"notifications" comment:nil],[objLanguagehandler VJLocalizedString:@"reviews" comment:nil],[objLanguagehandler VJLocalizedString:@"change_password" comment:nil],*/[objLanguagehandler VJLocalizedString:@"my_earnings" comment:nil],[objLanguagehandler VJLocalizedString:@"my_docs_menu" comment:nil],/*[objLanguagehandler VJLocalizedString:@"chat" comment:nil],*/[objLanguagehandler VJLocalizedString:@"banking_details" comment:nil], [objLanguagehandler VJLocalizedString:@"about" comment:nil],[objLanguagehandler VJLocalizedString:@"logout" comment:nil],nil];
            
            ImgArray=[[NSMutableArray alloc]initWithObjects:@"MenuHome",@"MenuOrders"/*,@"Transaction",@"notification",@"review",@"MenuProfile"*/,@"menu_earnings",@"Menu_Documents",/*@"ChatImg",*/@"MenuBanking",@"About-30",@"logout" ,nil];
        }
        
    }else{
        if ([objTheme.getDocumentStatus isEqual: @"0"]){
            titleArray=[[NSMutableArray alloc]initWithObjects:[objLanguagehandler VJLocalizedString:@"home" comment:nil],[objLanguagehandler VJLocalizedString:@"my_jobs" comment:nil],/*[objLanguagehandler VJLocalizedString:@"transactions" comment:nil],[objLanguagehandler VJLocalizedString:@"notifications" comment:nil],[objLanguagehandler VJLocalizedString:@"reviews" comment:nil],[objLanguagehandler VJLocalizedString:@"change_password" comment:nil],*/[objLanguagehandler VJLocalizedString:@"my_earnings" comment:nil],/*[objLanguagehandler VJLocalizedString:@"chat" comment:nil],*/[objLanguagehandler VJLocalizedString:@"banking_details" comment:nil], [objLanguagehandler VJLocalizedString:@"about" comment:nil],[objLanguagehandler VJLocalizedString:@"Language" comment:nil],[objLanguagehandler VJLocalizedString:@"logout" comment:nil],nil];
            
            ImgArray=[[NSMutableArray alloc]initWithObjects:@"MenuHome",@"MenuOrders"/*,@"Transaction",@"notification",@"review",@"MenuProfile"*/,@"menu_earnings",/*@"ChatImg",*/@"MenuBanking",@"About-30",@"menu_language",@"logout" ,nil];
        }else{
            titleArray=[[NSMutableArray alloc]initWithObjects:[objLanguagehandler VJLocalizedString:@"home" comment:nil],[objLanguagehandler VJLocalizedString:@"my_jobs" comment:nil],/*[objLanguagehandler VJLocalizedString:@"transactions" comment:nil],[objLanguagehandler VJLocalizedString:@"notifications" comment:nil],[objLanguagehandler VJLocalizedString:@"reviews" comment:nil],[objLanguagehandler VJLocalizedString:@"change_password" comment:nil],*/[objLanguagehandler VJLocalizedString:@"my_earnings" comment:nil],[objLanguagehandler VJLocalizedString:@"my_docs_menu" comment:nil],/*[objLanguagehandler VJLocalizedString:@"chat" comment:nil],*/[objLanguagehandler VJLocalizedString:@"banking_details" comment:nil], [objLanguagehandler VJLocalizedString:@"about" comment:nil],[objLanguagehandler VJLocalizedString:@"Language" comment:nil],[objLanguagehandler VJLocalizedString:@"logout" comment:nil],nil];
            
            ImgArray=[[NSMutableArray alloc]initWithObjects:@"MenuHome",@"MenuOrders"/*,@"Transaction",@"notification",@"review",@"MenuProfile"*/,@"menu_earnings",@"Menu_Documents",/*@"ChatImg",*/@"MenuBanking",@"About-30",@"menu_language",@"logout" ,nil];
        }
        
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1.0f];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 190.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        NSString * str=[self getUserImage];
        NSLog(@"get userimage=%@",str);
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"PlaceHolderSmall"]];
        
        //        [imageView loadImageFromURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"PlaceHolderSmall"] cachingKey:trimmedString];
        
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor colorWithRed:248/255.0f green:130/255.0f blue:4/255.0f alpha:1.0f].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        UIButton *EditprofilePic = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, 100, 100)];
        EditprofilePic.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [EditprofilePic addTarget:self action:@selector(EditbtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
//          objTheme=[[Theme alloc]init];
        UserInfoRecord * objrec=(UserInfoRecord *)[objTheme GetUserDetails];
        
     //NSString * proname = objrec.p
//        label.text = objrec.providerName;
        label.text = [objTheme getFullName];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 0, 24)];
        label2.text = [objTheme setLang:@"Acc_Not_Verified"];
        label2.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        label2.textColor = [UIColor redColor];
        label2.backgroundColor = [UIColor clearColor];
        [label2 sizeToFit];
        label2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        if ([objTheme getVerifiedStatus] == 0){
            [view addSubview:label2];
        }
        [view addSubview:EditprofilePic];
        view;
    });
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
}


-(IBAction)EditbtnTapped:(id)sender{
    DEMONavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"StarterNavVCSID"];
    ExpertProfileViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExpertProfileViewController"];
    navigationController.viewControllers = @[homeViewController];
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Delegate


-(void)buttonClicked:(id)sender{
   

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell startCanvasAnimation];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor whiteColor];
    //[UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DEMONavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"StarterNavVCSID"];
    
    if ( indexPath.row == 0) {
        HomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVCSID"];
        navigationController.viewControllers = @[homeViewController];
    } else if(indexPath.row==1) {
        MyJobsViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyJobsVCSID"];
        navigationController.viewControllers = @[homeViewController];
    }else if(indexPath.row==2) {
        NewEarningsViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewEarningsVCID"];
        navigationController.viewControllers = @[homeViewController];
    }
//    else if(indexPath.row==3) {
//        ChatListViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatListVcSID"];
//        navigationController.viewControllers = @[homeViewController];
//    }
//    else if (indexPath.row == 2)
//    {
//        TransactionVC *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionVC"];
//        navigationController.viewControllers = @[homeViewController];
//
//    }
//    else if (indexPath.row == 3)
//    {
//        NotificationsVCViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Notification"];
//        navigationController.viewControllers = @[homeViewController];
//    }
//    else if (indexPath.row == 4)
//    {
//        ReviewViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"review"];
//        navigationController.viewControllers = @[homeViewController];
//
//    }
//    else if(indexPath.row==5) {
//
//        ChangePasswordViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Changepassword"];
//        navigationController.viewControllers = @[homeViewController];
//
//
//    }
    if(indexPath.row==3) {
        if ([objTheme.getDocumentStatus  isEqualToString:@"0"]) {
            BankingInforViewControler *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bankingVC"];
            navigationController.viewControllers = @[homeViewController];
        } else {
            MyDocumentsViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyDocumentsVC"];
            navigationController.viewControllers = @[homeViewController];
        }
        
    }
    if(indexPath.row==4) {
        BankingInforViewControler *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bankingVC"];
        navigationController.viewControllers = @[homeViewController];
    }
  
    else if(indexPath.row==5) {
        AboutUSViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutusVCSID"];
        navigationController.viewControllers = @[homeViewController];
        
    }
//    }else if(indexPath.row==9) {
//        
//        ChangePasswordViewController*homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Language"];
//        navigationController.viewControllers = @[homeViewController];
//    }
    
    else if(indexPath.row==6) {
        NSString *myObject = [objTheme appName];
        if (objTheme.isLanguageManagement == 0){
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:myObject
                                         message:[objTheme setLang: @"Logout_hme"]
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:[objTheme setLang: @"ok"]
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [self LogoutMethod];
                                        }];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:[objTheme setLang: @"cancel"]
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle no, thanks button
                                       }];
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            ChangeLanguageViewController*homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Language"];
            navigationController.viewControllers = @[homeViewController];
        }
    }
    else if(indexPath.row==7) {
        NSString *myObject = [objTheme appName];
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:myObject
                                     message:[objTheme setLang: @"Logout_hme"]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[objTheme setLang: @"ok"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [self LogoutMethod];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:[objTheme setLang: @"cancel"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
//    else if(indexPath.row==9) {
//        [self performSelector:@selector(openEmailfeedback) withObject:self afterDelay:0.3];
//    }
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}




//func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//    //MARK:- Fade transition Animation
//    cell.alpha = 0
//    UIView.animate(withDuration: 0.33) {
//        cell.alpha = 1
//    }
//
//    //MARK:- Curl transition Animation
//    // cell.layer.transform = CATransform3DScale(CATransform3DIdentity, -1, 1, 1)
//
//    // UIView.animate(withDuration: 0.4) {
//    //  cell.layer.transform = CATransform3DIdentity
//    //}
//
//    //MARK:- Frame Translation Animation
//    //cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -cell.frame.width, 1, 1)
//
//    // UIView.animate(withDuration: 0.33) {
//    //  cell.layer.transform = CATransform3DIdentity
//    // }
//}




-(void)openEmailfeedback{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"feedBackEmail"
     object:self userInfo:nil];
}

//-(void)Logout{
//    
//    [self showActivityIndicator:YES];
//    UrlHandler *web = [UrlHandler UrlsharedHandler];
//    [web LogoutDriver:[self setParametersForLogout]
//              success:^(NSMutableDictionary *responseDictionary)
//     {
//         [self stopActivityIndicator];
//         //if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
//         AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
//         [Theme ClearUserDetails];
//         LoginViewController * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialVCSID"];
//         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
//         testAppDelegate.window.rootViewController = navigationController;
//         self.view.userInteractionEnabled=YES;
//         //         }else{
//         //
//         //             [self.view makeToast:kErrorMessage];
//         //         }
//     }
//              failure:^(NSError *error)
//     {
//         
//         [self stopActivityIndicator];
//         AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
//         [Theme ClearUserDetails];
//         LoginViewController * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialVCSID"];
//         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
//         testAppDelegate.window.rootViewController = navigationController;
//         self.view.userInteractionEnabled=YES;
//         [self.view makeToast:kErrorMessage];
//         
//     }];
//}
//-(void)showActivityIndicator:(BOOL)isShow{
//    if(isShow==YES){
//        if(custIndicatorView==nil){
//            custIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleBounce color:SetBlueColor];
//            
//        }
//        custIndicatorView.center =self.view.center;
//        [custIndicatorView startAnimating];
//        [self.view addSubview:custIndicatorView];
//        [self.view bringSubviewToFront:custIndicatorView];
//    }
//}
//-(void)stopActivityIndicator{
//    [custIndicatorView stopAnimating];
//    custIndicatorView=nil;
//}
//-(NSDictionary *)setParametersForLogout{
//    NSString * driverId=@"";
//    if([Theme UserIsLogin]){
//        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
//        driverId=[myDictionary objectForKey:@"driver_id"];
//    }
//    NSDictionary *dictForuser = @{
//                                  @"driver_id":driverId,
//                                  @"device":@"IOS"
//                                  };
//    return dictForuser;
//}

#pragma mark -
#pragma mark UITableView Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==[titleArray count]){
        return 50;
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NormalCellIdentifier = @"MenuListIdentifier";
    
    //    if(indexPath.row==([titleArray count])){ //This is last cell so create normal cell
    //        UITableViewCell *lastcell = [tableView dequeueReusableCellWithIdentifier:lastCellIdentifier];
    //        if(!lastcell){
    //            lastcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastCellIdentifier];
    //            CGRect frame = CGRectMake((self.tableView.frame.size.width/2)-(200/2),40,200,50);
    //            UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //            [aButton addTarget:self action:@selector(btnAddRowTapped:) forControlEvents:UIControlEventTouchUpInside];
    //            aButton.frame = frame;
    //            aButton.layer.cornerRadius=5;
    //            aButton.layer.masksToBounds=YES;
    //             [aButton setTitle:[objLanguagehandler VJLocalizedString:@"logout" comment:nil] forState:UIControlStateNormal];
    ////            aButton=[Theme setBoldFontForButton:aButton];
    //            aButton.backgroundColor=[UIColor colorWithRed:248/255.0f green:130/255.0f blue:4/255.0f alpha:1.0f];
    //            aButton.titleLabel.textColor=[UIColor whiteColor];
    //            [lastcell addSubview:aButton];
    //            lastcell.separatorInset = UIEdgeInsetsMake(0.f, lastcell.bounds.size.width, 0.f, 0.f);
    //        }
    //        return lastcell;
    //    }else{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:NormalCellIdentifier];
    }
    cell.animation_view.type = CSAnimationTypeBounceRight;
    cell.animation_view.duration = 1.0;
    cell.animation_view.delay = 0.1;
    cell.titleLbl.text=[titleArray objectAtIndex:indexPath.row];
    cell.IconImgView.image=[UIImage imageNamed:[ImgArray objectAtIndex:indexPath.row]];
    [cell.IconImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    cell.IconImgView.tintColor = [UIColor colorWithRed:248/255.0 green:130/255.0 blue:4/255.0 alpha:1];
    cell.IconImgView.tintColor = [objTheme ThemeColour];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
-(NSString*)getUserImage
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfoImgDictKey"];
}

-(void)LogoutMethod
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"logout" object:nil];
 
}
-(IBAction)btnAddRowTapped:(id)sender{
    
}
@end
