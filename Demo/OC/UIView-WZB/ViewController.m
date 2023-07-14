//
//  ViewController.m
//  UIView-WZB
//
//  Created by 王振标 on 2016/11/28.
//  Copyright © 2016年 王振标. All rights reserved.
//

#import "ViewController.h"
#import "UIView+WZB.h"
#import "DetailViewController.h"

#define WZBHeight [UIScreen mainScreen].bounds.size.height
#define WZBWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *v1 = [[UIView alloc] initWithFrame:(CGRect){1, 50, WZBWidth - 2, 80}];
    [self.view addSubview:v1];
    // 在v1上画一个4列3行的表格
    /**
     * 创建一个表格
     * line：列数
     * columns：行数
     * data：数据
     */
    [v1 wzb_drawListWithRect:v1.bounds columns:4 rows:3 datas:@[@"", @"语文", @"数学", @"英语", @"王晓明", @"100.5", @"128", @"95", @"李小华", @"100.5", @"128", @"95", @"张爱奇", @"100.5", @"128", @"95"]];
    
    
    UIView *v2 = [[UIView alloc] initWithFrame:(CGRect){10, 160, WZBWidth - 20, 170}];
    [self.view addSubview:v2];
    // 在v2上画一个5列4行的表格，colorInfo：第2个、第6个、第11个、第16个显示红色文字，backgroundColorInfo：第0个、第5个、第12个背景颜色为黄色
    [v2 wzb_drawListWithRect:v2.bounds columns:5 rows:4 datas:@[@"三等奖入选名单（黄色为队长）", @"一队", @"李小华", @"欧阳大大", @"李丽", @"史泰龙", @"二队", @"孙志鹏", @"李来德", @"希特勒", @"二狗子", @"三队", @"杰森·史坦森", @"阿莫西林", @"米其林", @"土豆", @"四队", @"乔丹", @"Angly", @"斯瓦辛格", @"狗带🐶"] colorInfo:@{@"1" : [UIColor redColor], @"6" : [UIColor redColor], @"11" : [UIColor redColor], @"16" : [UIColor redColor]} columnsInfo:@{@"0" : @"1"} backgroundColorInfo:@{@"5" : [UIColor yellowColor], @"9" : [UIColor yellowColor], @"12" : [UIColor yellowColor]}];
    // 拿到v2上第一个label设置属性
    UILabel *label = [v2 getLabelWithIndex:0];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor purpleColor];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:(CGRect){1, 370, WZBWidth - 2, 150}];
    [self.view addSubview:v3];
    // 在v2上画一个5列4行的表格，lineInfo：第0行只显示1列
    [v3 wzb_drawListWithRect:v3.bounds columns:3 rows:5 datas:@[@"12月份各地区销售额（万）", @"广东地区", @"4685.36", @"查看详情", @"河南地区", @"6894.09", @"查看详情", @"东北地区", @"10452.78", @"查看详情", @"上海地区", @"12882.78", @"查看详情"] columnsInfo:@{@"0" : @"1"}];
    // 拿到后边三个label，添加单击手势
    for (NSInteger i = 3; i < 13; i += 3) {
        UILabel *label = [v3 getLabelWithIndex:i];
        label.textColor = [UIColor blueColor];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overDetail)]];
    }
    
    // 画一些线
    for (NSInteger i = 0; i < WZBWidth; i++) {
        CGFloat x = i;
        CGFloat y = CGRectGetMaxY(v3.frame) + 10;
        CGFloat h = WZBHeight - y;
        [self.view wzb_drawLineWithFrame:(CGRect){x, y, 1, h} lineType:WZBLineVertical color:[self randomColor] lineWidth:5];
    }
}

- (void)overDetail {
    [self presentViewController:[DetailViewController new] animated:YES completion:nil];
}

// 随机颜色
- (UIColor *)randomColor {
    return [UIColor colorWithRed:(arc4random_uniform(255))/255.0 green:(arc4random_uniform(255))/255.0 blue:(arc4random_uniform(255))/255.0 alpha:1];
}

@end
