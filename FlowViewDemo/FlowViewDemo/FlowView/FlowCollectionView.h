//
//  FlowCollectionView.h
//  FlowViewDemo
//
//  Created by 史庆帅 on 16/9/2.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FlowDirection){
    FlowDirectionLeft,
    FlowDirectionRight
};
@interface FlowCollectionView : UICollectionView
+ (instancetype)flowCollectionViewWithFrame:(CGRect)frame layout:(UICollectionViewLayout *)layout;
@property (nonatomic) NSArray *images;
//翻页的长度
@property (nonatomic) CGFloat pageLength;
@end
