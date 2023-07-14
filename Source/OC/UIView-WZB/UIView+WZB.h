//
//  UIView+WZB.h
//  WZBListView
//
//  Created by 王振标 on 16/6/13.
//  Copyright © 2016年 王振标. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WZBLineType) {
    WZBLineVertical,  // 垂直
    WZBLineHorizontal // 水平
};

@interface UIView (WZB)

/**
 * 创建一个表格
 * columns：列数
 * rows：行数
 * data：数据
 */
- (void)wzb_drawListWithRect:(CGRect)rect columns:(NSInteger)columns rows:(NSInteger)rows datas:(NSArray *)datas;

/**
 * 创建一个表格
 * columns：列数
 * rows：行数
 * data：数据
 * lineInfo：行信息，传入格式：@{@"0" : @"3"}意味着第一行创建3个格子
 */
- (void)wzb_drawListWithRect:(CGRect)rect columns:(NSInteger)columns rows:(NSInteger)rows datas:(NSArray *)datas columnsInfo:(NSDictionary *)columnsInfo;

/**
 * 创建一个表格
 * line：列数
 * rows：行数
 * data：数据
 * colorInfo：颜色信息，传入格式：@{@"0" : [UIColor redColor]}意味着第一个格子文字将会变成红色
 */
- (void)wzb_drawListWithRect:(CGRect)rect columns:(NSInteger)columns rows:(NSInteger)rows datas:(NSArray *)datas colorInfo:(NSDictionary *)colorInfo;
/**
 * 创建一个表格
 * columns：列数
 * rows：行数
 * data：数据
 * colorInfo：颜色信息，传入格式：@{@"0" : [UIColor redColor]}意味着第一个格子文字将会变成红色
 * columnsInfo：行信息，传入格式：@{@"0" : @"3"}意味着第一行创建3个格子
 */
- (void)wzb_drawListWithRect:(CGRect)rect columns:(NSInteger)columns rows:(NSInteger)rows datas:(NSArray *)datas colorInfo:(NSDictionary *)colorInfo columnsInfo:(NSDictionary *)columnsInfo;
/**
 * 创建一个表格
 * columns：列数
 * rows：行数
 * data：数据
 * colorInfo：颜色信息，传入格式：@{@"0" : [UIColor redColor]}意味着第一个格子文字将会变成红色
 * columnsInfo：行信息，传入格式：@{@"0" : @"3"}意味着第一行创建3个格子
 * backgroundColorInfo：行信息，传入格式：@{@"0" : [UIColor redColor]}意味着第一个格子背景颜色变成红色
 */
- (void)wzb_drawListWithRect:(CGRect)rect columns:(NSInteger)columns rows:(NSInteger)rows datas:(NSArray *)datas colorInfo:(NSDictionary *)colorInfo columnsInfo:(NSDictionary *)columnsInfo backgroundColorInfo:(NSDictionary *)backgroundColorInfo;
/**
 * 获取第index个格子的label
 */
- (UILabel *)getLabelWithIndex:(NSInteger)index;

/**
 * 画一条线
 * frame: 线的frame
 * color：线的颜色
 * lineWidth：线宽
 */
- (void)wzb_drawLineWithFrame:(CGRect)frame lineType:(WZBLineType)lineType color:(UIColor *)color lineWidth:(CGFloat)lineWidth;

@end
