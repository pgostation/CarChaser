//
//  Resources.h
//  CarChaser
//
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#define Y_CONV(_x) (size.height-(_x))

#define TOUCH_MODE 0
#define TILT_MODE 1

@interface Resources : NSObject
{
    NSMutableArray *bombAnimFrame;
    float accellometer_y;
    float highspeed_;
    int highscore_;
    int control_mode_;
}

@property (assign) float highspeed;
@property (assign) int highscore;
@property (assign) int control_mode;

//Util
+(Resources *) getResource;
-(NSMutableArray *) animationFrameWithRects:(NSString*)filename rects:(CGRect *)rects framecount:(int)framecount;
-(void) syncHighScore;
-(void) gameCenterSubmit:(int)score highspeed:(float)speed;
-(void) setAccelometer:(float)accellometer_y;
-(float) getAccelometer;

//Get Image Rect
-(CGRect) getCarIconRect:(int)num;
//-(CGRect) getBombIconRect:(int)num;
-(CGRect) getRoadImageRect;

//Id
-(int) getControllerId:(int)num;
-(int) getRoadId:(int)num;
-(int) getMyCarId;
-(int) getEnemyCarId:(int)num;

//Animation
-(CCSpriteFrame*) getBombAnim:(int)num;

@end
