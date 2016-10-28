//
//  ViewController.m
//  RXUMDemo2
//
//  Created by srx on 2016/10/24.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "ViewController.h"
#import "RXUMShare.h"
#import "Header.h"

@interface ViewController ()
{
    RXUMShare * _share;
    NSMutableArray * _platforms;
}

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
- (IBAction)shareButtonClick:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _share = [[RXUMShare alloc] init];
    [self.view addSubview:_share];
    
    _platforms = [[NSMutableArray alloc] init];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, ScreenHeight - 25, ScreenWidth, 25);
    backButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.4 blue:1 alpha:0.5];
    [backButton setTitle:@"还原" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)backButtonClick {
    for (UITableViewCell* cell in self.tableView.visibleCells) {
        
        for (UIView * subView in cell.contentView.subviews) {
            if([subView isKindOfClass:[UISwitch class]]) {
                UISwitch * switchView = (UISwitch *)subView;
                switchView.on = NO;
            }
        }
    }
    
     [_platforms removeAllObjects];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //测试合并。。。。PR
    //测试合并2。。。pr
}




- (IBAction)shareButtonClick:(id)sender {
    [_platforms removeAllObjects];
    NSInteger i = 0;
    for (UITableViewCell* cell in self.tableView.visibleCells) {
        
        for (UIView * subView in cell.contentView.subviews) {
            if([subView isKindOfClass:[UISwitch class]]) {
                UISwitch * switchView = (UISwitch *)subView;
                if(switchView.on) {
                    switch (i) {
                        case 0:
                            [_platforms addObject:UMSPlatformNameQzone];
                            break;
                        case 1:
                            [_platforms addObject:UMSPlatformNameQQ];
                            break;
                        case 2:
                            [_platforms addObject:UMSPlatformNameAlipaySession];
                            break;
                        case 3:
                            [_platforms addObject:UMSPlatformNameWechatSession];
                            break;
                        case 4:
                            [_platforms addObject:UMSPlatformNameWechatTimeline];
                            break;
                        case 5:
                            [_platforms addObject:UMSPlatformNameTencentWb];
                            break;
                        case 6:
                            [_platforms addObject:UMSPlatformNameRenren];
                            break;
                        case 7:
                            [_platforms addObject:UMSPlatformNameSina];
                            break;
                        case 8:
                            [_platforms addObject:UMSPlatformNameFacebook];
                            break;
                        case 9:
                            [_platforms addObject:UMSPlatformNameTwitter];
                            break;
                    }
                    
                }
            }
        }
        
        i ++;
    };
    
    if(_platforms.count <= 0) return;
    
    [_share shareInController:self platforms:_platforms title:@"biaoti" contents:@"" imageURLString:@"" completion:^(NSString *result) {
        
    }];
    
    
//    [_share shareInController:self platforms:@[UMSPlatformNameQQ, UMSPlatformNameQzone, UMSPlatformNameWechatSession, UMSPlatformNameTencentWb , UMSPlatformNameSina] title:@"标题" contents:@"分享内容" imageURLString:@"图片url" completion:^(NSString *result) {
//        //result=分享成功、失败等等信息
//    }];
}


@end
