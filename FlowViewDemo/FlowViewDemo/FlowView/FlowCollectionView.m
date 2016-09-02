//
//  FlowCollectionView.m
//  FlowViewDemo
//
//  Created by 史庆帅 on 16/9/2.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "FlowCollectionView.h"

#import "FlowViewCell.h"
#import "CustomFlowLayout.h"

@interface FlowCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) CGFloat contentWidth;
@property (nonatomic) FlowDirection direction;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGPoint velocity;
@property (nonatomic) CGPoint targetPoint;
@property (nonatomic) CGFloat itemLength;
@property (nonatomic) NSMutableArray *itemImages;
@end
@implementation FlowCollectionView
+ (instancetype)flowCollectionViewWithFrame:(CGRect)frame layout:(UICollectionViewLayout *)layout{
    return [[self alloc]initWithFrame:frame collectionViewLayout:layout];
}
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if(self = [super initWithFrame:frame collectionViewLayout:layout]){
        self.itemImages = [NSMutableArray array];
        CustomFlowLayout *flowLayout = (CustomFlowLayout*)layout;
        self.itemLength = flowLayout.itemSize.width;
        self.pageLength = self.frame.size.width;
        self.bounces = NO;
        self.delegate = self;
        self.dataSource = self;
        self.decelerationRate = 0.1;
        self.pagingEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([FlowViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([FlowViewCell class])];
        self.contentSize = CGSizeMake(self.frame.size.width/2*3, self.frame.size.height);
        [self scrollRectToVisible:CGRectMake(flowLayout.itemSize.width/2, 0, self.frame.size.width, self.frame.size.height) animated:NO];
    }
    return self;
}
- (void)setImages:(NSArray *)images{
    _images = images;
    [self.itemImages removeAllObjects];
    [self.itemImages addObject:@""];
    [self.itemImages addObjectsFromArray:images];
    [self.itemImages addObject:@""];
    [self reloadData];
}
#pragma mark collectionView的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FlowViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FlowViewCell class]) forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.itemImages[indexPath.row]];
    return cell;
}

#pragma mark scrollView的代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

//开始减速过程
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}

//即将开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.startPoint = scrollView.contentOffset;
}
//即将结束拖动
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    self.velocity = velocity;
    
    self.endPoint = scrollView.contentOffset;
    self.direction = self.startPoint.x <= self.endPoint.x ? FlowDirectionRight : FlowDirectionLeft;

    CGFloat x = targetContentOffset->x;
    CGFloat y = targetContentOffset->y;
    self.targetPoint = CGPointMake(x, y);
    
    
    NSInteger currentPage = [self currentPageWithScrollView:scrollView];
    CGFloat overOffsetX = scrollView.contentOffset.x -  currentPage* self.pageLength - self.itemLength/2;
    //滑动到最左端时进行等位
    if(overOffsetX < 0){
        
        targetContentOffset->x = self.contentOffset.x;
        [scrollView setContentOffset:CGPointMake(self.itemLength/2, 0) animated:YES];
        
        return;
    }
    //滑动最右端时进行定位
    CGFloat maxOffsetX = (self.contentSize.width - self.frame.size.width - self.itemLength/2);
    if(self.contentOffset.x > maxOffsetX){
        targetContentOffset->x = self.contentOffset.x;
        [scrollView setContentOffset:CGPointMake(maxOffsetX, 0) animated:YES];
        return;
    }
    if(self.direction == FlowDirectionRight){
        if(overOffsetX >= self.pageLength/7){
            targetContentOffset->x = (currentPage+1)*self.pageLength+self.itemLength/2;
        }else{
            if(self.velocity.x == 0){
                targetContentOffset->x = (currentPage)*self.pageLength+self.itemLength/2;
            }else{
                
                targetContentOffset->x = scrollView.contentOffset.x;
                [scrollView setContentOffset:CGPointMake((currentPage)*self.pageLength+self.itemLength/2, 0) animated:YES];
            }
            
        }
    }else{
        if(overOffsetX >= self.pageLength/7*6){
            if(self.velocity.x == 0){
                targetContentOffset->x = (currentPage+1)*self.pageLength+self.itemLength/2;
            }else{
                targetContentOffset->x = scrollView.contentOffset.x;
                [scrollView setContentOffset:CGPointMake((currentPage+1)*self.pageLength+self.itemLength/2, 0) animated:YES];
            }
        }else{
            targetContentOffset->x = (currentPage)*self.pageLength+self.itemLength/2;
        }
    }
}


- (NSInteger)currentPageWithScrollView:(UIScrollView *)scrollView{
    NSInteger page = (scrollView.contentOffset.x - self.itemLength/2) / self.pageLength;
    return page;
}
@end
