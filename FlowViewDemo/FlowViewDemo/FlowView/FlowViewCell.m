//
//  FlowViewCell.m
//  FlowViewDemo
//
//  Created by 史庆帅 on 16/9/2.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "FlowViewCell.h"

@implementation FlowViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.cornerRadius = 5;
    self.imageView.clipsToBounds = YES;
}
@end
