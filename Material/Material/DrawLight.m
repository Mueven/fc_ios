//
//  DrawLight.m
//  Material
//
//  Created by wayne on 14-8-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "DrawLight.h"
@interface DrawLight()
@property(nonatomic)CGFloat width;
@property(nonatomic)CGFloat height;
@property(nonatomic)CGFloat beginX;
@property(nonatomic)CGFloat beginY;
@property(nonatomic)CGFloat topX;
@property(nonatomic)CGFloat offsetY;
@property(nonatomic)CGFloat pathWidth;
@property(nonatomic)CGFloat radius;
@property(nonatomic,strong)NSString *color;
@property(nonatomic,strong)NSDictionary *colorRef;
@end
@implementation DrawLight
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.color=@"clear";
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame color:(NSString *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.colorRef=@{
                        @"red":@[@248.0,@94.0,@100.0],
                        @"blue":@[@66.0,@120.0,@207.0],
                        @"green":@[@87.0,@188.0,@96.0]
                        };
        self.color=color;
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.width=90;
    self.height=60;
    self.beginX=55;
    self.beginY=29;
    self.topX=50;
    self.offsetY=18;
    self.pathWidth=1;
    self.radius=33;
    
    [self drawBox];
    [self drawLight];
}
-(void)drawBox
{
    UIBezierPath *path=[[UIBezierPath alloc] init];
   
    CGPoint first=CGPointMake(self.beginX, self.beginY+self.offsetY);
    CGPoint second=CGPointMake(self.beginX+self.width, self.beginY+self.offsetY);
    CGPoint third=CGPointMake(self.beginX+self.width, self.beginY+self.height+self.offsetY);
    CGPoint fourth=CGPointMake(self.beginX, self.beginY+self.height+self.offsetY);
    CGPoint topFirst=CGPointMake(self.beginX+self.topX,self.pathWidth+self.offsetY);
    CGPoint topSecond=CGPointMake(self.beginX+self.topX+self.width-12, self.pathWidth+self.offsetY);
    CGPoint rightFirst=CGPointMake(self.beginX+self.topX+self.width-12, self.pathWidth+self.height+self.offsetY-8);
    
    [path moveToPoint:first];
    [path addLineToPoint:second];
    [path addLineToPoint:third];
    [path addLineToPoint:fourth];
    [path addLineToPoint:first];
    [path addLineToPoint:topFirst];
    [path addLineToPoint:topSecond];
    [path addLineToPoint:rightFirst];
    [path addLineToPoint:third];
    [path moveToPoint:second];
    [path addLineToPoint:topSecond];
    
    path.lineWidth=self.pathWidth;
    [[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6] setStroke];
    [[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05] setFill];
    [path fill];
    [path stroke];
}
-(void)drawLight
{
    UIBezierPath *path=[[UIBezierPath alloc] init];

    CGPoint center=CGPointMake(self.beginX+self.width/2+20, (self.beginY-self.pathWidth)/2+3+self.offsetY);
    
    [path moveToPoint:center];
    [path addArcWithCenter:center
                    radius:self.radius
                startAngle:0.0
                  endAngle:M_PI
                 clockwise:NO];
    [path addLineToPoint:center];
    [[self parseColor:self.color] setFill];
    [path fill];
    path.lineWidth=self.pathWidth;
    [[self parseColor:self.color] setStroke];
    [path stroke];
    
    CGPoint left=CGPointMake(center.x-self.radius-0.0, center.y);
    CGPoint right=CGPointMake(center.x+self.radius+0.0, center.y);
    UIBezierPath *linePath=[[UIBezierPath alloc] init];
    [linePath moveToPoint:left];
    [linePath addLineToPoint:right];
    linePath.lineWidth=self.pathWidth;
    [[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4] setStroke];
    [linePath stroke];

}
-(UIColor *)parseColor:(NSString *)key{
    if(self.colorRef[key]){
        NSArray *colorArray=self.colorRef[key];
        return [UIColor colorWithRed:[colorArray[0] floatValue]/255.0 green:[colorArray[1] floatValue]/255.0 blue:[colorArray[2] floatValue]/255.0 alpha:1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}
@end
