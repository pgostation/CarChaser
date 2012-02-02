//
//  Opening.h
//  CarChaser
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface OpeningLayer : CCLayer
{
    CCSpriteBatchNode *roadSpr;
    int count;
}

+(CCScene *) scene;

@end



@interface BlackLayer : CCLayer
{
    CCScene *pushedScene;
    float times;
}

+(CCScene *) sceneWithPushScene:(CCScene *)pushedScene;

@end
