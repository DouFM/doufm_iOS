//
//  DouFMSettingController.m
//  DouFm
//
//  Created by jackie on 14-6-5.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

NSString *kTableCellID = @"kTableCellID";

#import "DouFMSettingController.h"
#import <MessageUI/MessageUI.h>

@interface DouFMSettingController()<MFMailComposeViewControllerDelegate>


@property (strong, nonatomic) NSArray *options;

@end

@implementation DouFMSettingController


- (void)viewDidLoad
{
    //坑爹的API，居然改不了返回键的名字...
//    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回"
//                                                                           style:UIBarButtonItemStyleBordered
//                                                                           target:self action:@selector(backToPrevious)];
    
    self.options = @[@"使用说明", @"关于我们", @"反馈意见"];
    
}

//-(void)backToPrevious
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)awakeFromNib
{
    self.navigationController.navigationItem.backBarButtonItem.title = @"返回";
    
}

#pragma mark -- UITalbeViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_options count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellID];

    cell.textLabel.text = [_options objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"settingVCID"];
    NSString *urlString;
    switch (indexPath.row)
    {
        case 0:
        {
            urlString = @"UsageDescription";
        }
            break;
        case 1:
        {
            urlString = @"AboutUs";
        }
            break;
        case 2:
        {
            NSString *emailTitle= @"DouFM iOS客户端反馈";
            NSString *emailBody = [NSString stringWithFormat:@"iOS %@",[UIDevice currentDevice].systemVersion];
            NSArray *toRecpents = [NSArray arrayWithObject:@"admin@doufm.info"];
            
            MFMailComposeViewController *emailVC = [[MFMailComposeViewController alloc]init];
            emailVC.mailComposeDelegate = self;
            [emailVC setSubject:emailTitle];
            [emailVC setMessageBody:emailBody isHTML:NO];
            [emailVC setToRecipients:toRecpents];
            [self presentViewController:emailVC animated:YES completion:nil];
            return;
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
    UIWebView *webView = (UIWebView *)[viewController.view viewWithTag:1];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:urlString ofType:@"html"] isDirectory:NO]]];
    
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            DLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            DLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            DLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            DLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
