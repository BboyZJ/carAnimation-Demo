//
//  ViewController.m
//  carAnimation-Demo
//
//  Created by 张建 on 2017/4/26.
//  Copyright © 2017年 JuZiShu. All rights reserved.
//

#import "ViewController.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<CAAnimationDelegate>

//开始
@property (nonatomic,strong)UIButton * startBtn;
//背景视图
@property (nonatomic,strong)UIView * backView;
//车
@property (nonatomic,strong)UIImageView * carImgView;
//前轮
@property (nonatomic,strong)UIImageView * frontWhell;
//后轮
@property (nonatomic,strong)UIImageView * backWhell;
//车灯
@property (nonatomic,strong)UIImageView * carLight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //开始按钮
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.frame = CGRectMake((kScreenW - 100) / 2.0, kScreenH - 60, 100, 40);
    _startBtn.backgroundColor = [UIColor redColor];
    [_startBtn setTitle:@"start" forState:UIControlStateNormal];
    [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_startBtn addTarget:self action:@selector(startButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBtn];
    
}

#pragma mark ---开始按钮---
-(void)startButton:(UIButton *)sender{
    
    //背景视图
    _backView = [[UIView alloc] initWithFrame:CGRectMake(40, 100, kScreenW - 80, 110)];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    //car
    _carImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _backView.bounds.size.width, _backView.bounds.size.height)];
    _carImgView.image = [UIImage imageNamed:@"porche"];
    [_backView addSubview:_carImgView];
    
    //carLight
    _carLight = [[UIImageView alloc] initWithFrame:CGRectMake(_backView.bounds.size.width - 105, _backView.bounds.size.height - 75, 50, 50)];
    _carLight.image = [UIImage imageNamed:@"porche-light"];
    [_backView addSubview:_carLight];
    
    //backWhell
    _backWhell = [[UIImageView alloc] initWithFrame:CGRectMake(3, 30, 20, 33)];
    _backWhell.image = [UIImage imageNamed:@"porche-back"];
    [_backView addSubview:_backWhell];
    
    //frontWhell
    _frontWhell = [[UIImageView alloc] initWithFrame:CGRectMake(_backView.bounds.size.width / 2.0 - 20, _backView.bounds.size.height - 55, 40, 50)];
    _frontWhell.image = [UIImage imageNamed:@"porche-front"];
    [_backView addSubview:_frontWhell];
    
    //animation
    [self setupAnimation];

}

- (void)setupAnimation{
    
    //缩放
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration =3.5;
    scaleAnimation.fromValue = @(0);
    scaleAnimation.toValue = @(0.8);
    scaleAnimation.beginTime = 0.0;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.repeatCount = 1;
    
    //位移
    //path
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 100)];
    [path addLineToPoint:CGPointMake(kScreenW / 2.0, kScreenH / 2.0)];
    //position
    CAKeyframeAnimation * positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.path = path.CGPath;
    positionAnimation.duration = 4.0;
    positionAnimation.autoreverses = NO;
    positionAnimation.repeatCount = 1;
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    positionAnimation.removedOnCompletion = NO;
    
    //位移2
    //path
    UIBezierPath * path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(kScreenW / 2.0, kScreenH / 2.0)];
    [path2 addLineToPoint:CGPointMake(kScreenW + 170, kScreenH / 2.0 + 120)];
    //position
    CAKeyframeAnimation * positionAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation2.path = path2.CGPath;
    positionAnimation2.beginTime = positionAnimation.duration;
    positionAnimation2.duration = 4.0;
    positionAnimation2.autoreverses = NO;
    positionAnimation2.repeatCount = 1;
    positionAnimation2.fillMode = kCAFillModeForwards;
    positionAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    positionAnimation2.removedOnCompletion = NO;
    
    //group
    CAAnimationGroup * groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = positionAnimation.duration + positionAnimation2.duration;
    groupAnimation.animations = @[scaleAnimation,positionAnimation,positionAnimation2];
    groupAnimation.repeatCount = 1;
    groupAnimation.delegate = self;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.removedOnCompletion = NO;
    [_backView.layer addAnimation:groupAnimation forKey:@"groupAnimation"];

    //旋转
    CABasicAnimation * transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    transformAnimation.fromValue = @(0);//起始值
    transformAnimation.toValue = @(M_PI * 2);//结束值
    transformAnimation.autoreverses = NO;//动画结束时是否执行逆动画
    transformAnimation.repeatCount = HUGE_VALF;//重复的次数，不停重复HUGE_VALF
    transformAnimation.beginTime = 0;//延迟2秒开始动画
    transformAnimation.speed = 5.0f;//动画的执行速度
    
    [_backWhell.layer addAnimation:transformAnimation forKey:@"backWhellAnimation"];
    
    [_frontWhell.layer addAnimation:transformAnimation forKey:@"frontWhellAnimation"];
    
}
- (void)animationDidStart:(CAAnimation *)anim{
    
    if ([_backView.layer valueForKey:@"groupAnimation"] == anim) {
        
        [_backView removeFromSuperview];
        _backView = nil;
    }
}

- (void)dealloc{
    
    [_backView removeFromSuperview];
    _backView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
