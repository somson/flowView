//
//  CustomFlowLayout.m
//  FlowViewDemo
//
//  Created by 史庆帅 on 16/9/2.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "CustomFlowLayout.h"

@implementation CustomFlowLayout
- (id)init{
    if(self = [super init]){
        self.itemSize = CGSizeMake(150, 150);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 0;
        self.sizeScale = 0.7;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    //可见frame
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.frame.size;
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:array.count];
    for(UICollectionViewLayoutAttributes *attributes in array)
    {
        UICollectionViewLayoutAttributes *newAttributes = [attributes copy];
        [allAttributes addObject:newAttributes];
        if(CGRectIntersectsRect(newAttributes.frame, visibleRect))
        {
            CGFloat distance = CGRectGetMidX(visibleRect) - newAttributes.center.x;
            CGFloat scale = ABS(distance)/(self.collectionView.frame.size.width/2);
            CGFloat adverseScale = ABS(1-scale);
            CGFloat trueScale = (1-self.sizeScale)*adverseScale + self.sizeScale;
            newAttributes.transform3D = CATransform3DMakeScale(trueScale, trueScale, 1.0);
            newAttributes.zIndex = 1;

        }
        
    }
    return allAttributes;
    return [super layoutAttributesForElementsInRect:rect];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    return proposedContentOffset;
}

@end
