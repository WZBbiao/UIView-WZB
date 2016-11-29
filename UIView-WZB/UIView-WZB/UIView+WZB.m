//
//  UIView+WZB.m
//  WZBListView
//
//  Created by 孙航 on 16/6/13.
//  Copyright © 2016年 江苏银丰. All rights reserved.
//

#import "UIView+WZB.h"

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

#define WZBTag 155158

@implementation UIView (WZB)
- (void)wzb_drawListWithRect:(CGRect)rect line:(NSInteger)line columns:(NSInteger)columns datas:(NSArray *)datas colorInfo:(NSDictionary *)colorInfo{
    [self wzb_drawListWithRect:rect line:line columns:columns datas:datas colorInfo:colorInfo lineInfo:nil];
}

- (void)wzb_drawListWithRect:(CGRect)rect line:(NSInteger)line columns:(NSInteger)columns datas:(NSArray *)datas colorInfo:(NSDictionary *)colorInfo lineInfo:(NSDictionary *)lineInfo {
    [self wzb_drawListWithRect:rect line:line columns:columns datas:datas colorInfo:colorInfo lineInfo:lineInfo backgroundColorInfo:nil];
}

/**
 * 创建一个表格
 * line：列数
 * columns：行数
 * data：数据
 * colorInfo：颜色信息，传入格式：@{@"0" : [UIColor redColor]}意味着第一个格子文字将会变成红色
 * lineInfo：行信息，传入格式：@{@"0" : @"3"}意味着第一行创建3个格子
 * backgroundColorInfo：行信息，传入格式：@{@"0" : [UIColor redColor]}意味着第一个格子背景颜色变成红色
 */
- (void)wzb_drawListWithRect:(CGRect)rect line:(NSInteger)line columns:(NSInteger)columns datas:(NSArray *)datas colorInfo:(NSDictionary *)colorInfo lineInfo:(NSDictionary *)lineInfo backgroundColorInfo:(NSDictionary *)backgroundColorInfo {
    NSInteger index = 0;
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat h = (1.0) * rect.size.height / columns;
    NSInteger newLine = 0;
    for (NSInteger i = 0; i < columns; i++) {
        if (lineInfo) {
            for (NSInteger a = 0; a < lineInfo.allKeys.count; a++) {
                NSInteger newColumn = [lineInfo.allKeys[a] integerValue];
                if (i == newColumn) {
                    newLine = [lineInfo[lineInfo.allKeys[a]] integerValue];
                } else {
                    newLine = line;
                }
            }
        } else {
            newLine = line;
        }
        for (NSInteger j = 0; j < newLine; j++) {
            
            // 线宽
            CGFloat w = (1.0) * rect.size.width / newLine;
            CGRect frame = (CGRect){x + w * j, y + h * i, w, h};
            
            // 画线
            [self wzb_drawRectWithRect:frame];
            
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            
            // 文字颜色
            UIColor *textColor = [colorInfo objectForKey:[NSString stringWithFormat:@"%zd", index]];
            if (!textColor) {
                textColor = [UIColor grayColor];
            }
            label.textColor = textColor;
            
            // 背景颜色
            UIColor *backgroundColor = [backgroundColorInfo objectForKey:[NSString stringWithFormat:@"%zd", index]];
            if (!backgroundColor) {
                backgroundColor = [UIColor clearColor];
            }
            label.backgroundColor = backgroundColor;
            
            label.font = [UIFont systemFontOfSize:13];
            label.text = datas[index];
            label.tag = WZBTag + index;
            index++;
        }
    }
}

- (void)wzb_drawRectWithRect:(CGRect)rect {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat w = (1.0) * rect.size.width;
    CGFloat h = (1.0) * rect.size.height;
    
    if (((int)(y * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        y += SINGLE_LINE_ADJUST_OFFSET;
    }
    if (((int)(x * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        x += SINGLE_LINE_ADJUST_OFFSET;
    }
    
    [self wzb_drawLineWithFrame:(CGRect){x, y, w, 1} type:1];
    [self wzb_drawLineWithFrame:(CGRect){x + w, y, 1, h} type:2];
    [self wzb_drawLineWithFrame:(CGRect){x, y + h, w, 1} type:1];
    [self wzb_drawLineWithFrame:(CGRect){x, y, 1, h} type:2];
}

- (void)wzb_drawLineWithFrame:(CGRect)frame lineType:(WZBLineType)lineType color:(UIColor *)color lineWidth:(CGFloat)lineWidth {
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    linePath.lineWidth = lineWidth;
    [linePath moveToPoint:CGPointMake(0, 0)];
    [linePath addLineToPoint: lineType == WZBLineHorizontal ? CGPointMake(frame.size.width, 0) : CGPointMake(0, frame.size.height)];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.strokeColor = color.CGColor;
    lineLayer.lineWidth = lineWidth;
    lineLayer.frame = frame;
    lineLayer.path = linePath.CGPath;
    [self.layer addSublayer:lineLayer];
}

- (void)wzb_drawLineWithFrame:(CGRect)frame type:(NSInteger)type color:(UIColor *)color {
    [self wzb_drawLineWithFrame:frame lineType:type color:color lineWidth:0.7];
}

- (void)wzb_drawLineWithFrame:(CGRect)frame type:(NSInteger)type {
    [self wzb_drawLineWithFrame:frame type:type color:[UIColor blackColor]];
}

/**
 * 创建一个表格
 * line：列数
 * columns：行数
 * data：数据
 */
- (void)wzb_drawListWithRect:(CGRect)rect line:(NSInteger)line columns:(NSInteger)columns datas:(NSArray *)datas {
    [self wzb_drawListWithRect:rect line:line columns:columns datas:datas colorInfo:nil];
}

/**
 * 创建一个表格
 * line：列数
 * columns：行数
 * data：数据
 * lineInfo：行信息，传入格式：@{@"0" : @"3"}意味着第一行创建3个格子
 */
- (void)wzb_drawListWithRect:(CGRect)rect line:(NSInteger)line columns:(NSInteger)columns datas:(NSArray *)datas lineInfo:(NSDictionary *)lineInfo {
    [self wzb_drawListWithRect:rect line:line columns:columns datas:datas colorInfo:nil lineInfo:lineInfo];
}

// 根据tag拿到对应的label
- (UILabel *)getLabelWithIndex:(NSInteger)index {
    
    // 为了防止self的subviews又重复的tag，拿到第一个
    for (UIView *v in self.subviews) {
        
        // 判断是否为label类
        if ([v isKindOfClass:[UILabel class]]) {
            
            // 强制转换
            UILabel *label = (UILabel *)v;
            if (v.tag == index + WZBTag) {
                return label;
            }
        }
    }
    return [self viewWithTag:index + WZBTag];
}

@end






