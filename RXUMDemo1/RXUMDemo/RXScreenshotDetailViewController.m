//
//  RXScreenshotDetailViewController.m
//  RXUMDemo
//
//  Created by srx on 2017/9/27.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import "RXScreenshotDetailViewController.h"

@interface RXScreenshotDetailViewController ()
{
    UIImageView * _lookImgView;
    NSInteger _showTag;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *textImageView;
- (IBAction)back:(id)sender;

@end

@implementation RXScreenshotDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageView.image = self.image;
    _imageView.tag = 1;
    
    _textImageView.image = self.textImage;
    _textImageView.tag = 2;
    
    _lookImgView = [[UIImageView alloc] init];
    _lookImgView.tag = 3;
    _lookImgView.frame = CGRectZero;
    [self.view addSubview:_lookImgView];
    
    [self addTapGesWithImgView:_imageView];
    [self addTapGesWithImgView:_textImageView];
    [self addTapGesWithImgView:_lookImgView];
}

- (void)addTapGesWithImgView:(UIImageView *)imgView{
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesClick:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [imgView addGestureRecognizer:tap];
}

- (void)tapGesClick:(UITapGestureRecognizer *)tap {
    if(tap.view.tag != 3) {
        UIImageView * imgView = (UIImageView *)tap.view;
        _lookImgView.image = imgView.image;
        _showTag = tap.view.tag;
        [self showAnimalWithFrame:imgView.frame];
    }
    else {
        UIImageView * imgView = (UIImageView *)[self.view viewWithTag:_showTag];
        [self closeAnimalWithFrame:imgView.frame];
    }
}

- (void)showAnimalWithFrame:(CGRect)frame {
    _lookImgView.frame = frame;
    _lookImgView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _lookImgView.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeAnimalWithFrame:(CGRect)frame {
    
    [UIView animateWithDuration:0.3 animations:^{
        _lookImgView.frame = frame;
    } completion:^(BOOL finished) {
        _lookImgView.frame = CGRectZero;
        _lookImgView.hidden = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
