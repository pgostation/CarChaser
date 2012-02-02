//
//  HelloWorldLayer.m
//  iCarChaser
//
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Opening.h"
#import "GameCenter.h"
#import "Resources.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        Resources *Rsrc = [Resources getResource];
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        if(Rsrc.control_mode == TOUCH_MODE)
        {
            //マルチタッチの許可
            CC_GLVIEW *glView = [[CCDirector sharedDirector] openGLView];
            [glView setMultipleTouchEnabled:YES];
            
            //タッチイベントの許可
            self.isTouchEnabled = YES;
            
            //辞書の作成
#define MAX_TOUCHES 3
            touchesDic = CFDictionaryCreateMutable(NULL, MAX_TOUCHES, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
            
            //タッチボタン
            {
                button[LeftButton] = [CCSprite spriteWithFile:@"controller2.png" rect:CGRectMake(0,0,64,64)];
                button[LeftButton].position = ccp(32,32);
                [self addChild:button[LeftButton] z:100 tag:[Rsrc getControllerId:LeftButton]];
                
                button[RightButton] = [CCSprite spriteWithFile:@"controller2.png" rect:CGRectMake(0,0,64,64)];
                button[RightButton].position = ccp(96,32);
                [button[RightButton] setRotation:180];
                [self addChild:button[RightButton] z:100 tag:[Rsrc getControllerId:RightButton]];
                
                button[BlakeButton] = [CCSprite spriteWithFile:@"controller2.png" rect:CGRectMake(0,0,64,64)];
                button[BlakeButton].position = ccp(size.width-32,32);
                [button[BlakeButton] setRotation:270];
                [self addChild:button[BlakeButton] z:100 tag:[Rsrc getControllerId:BlakeButton]];
                
                button[JumpButton] = [CCSprite spriteWithFile:@"controller2.png" rect:CGRectMake(0,0,64,64)];
                button[JumpButton].position = ccp(size.width-32,96);
                [button[JumpButton] setRotation:90];
                [self addChild:button[JumpButton] z:100 tag:[Rsrc getControllerId:JumpButton]];
                
                /*analog[analogLR] = [CCSprite spriteWithFile:@"controller2.png" rect:CGRectMake(0,0,64,64)];
                 analog[analogLR].position = ccp(48,32);
                 [self addChild:analog[analogLR] z:101];
                 [analog[analogLR] setScale:1.5f];
                 
                 analog[analogUD] = [CCSprite spriteWithFile:@"controller2.png" rect:CGRectMake(0,0,64,64)];
                 analog[analogUD].position = ccp(size.width-24,48);
                 [self addChild:analog[analogUD] z:101];
                 [analog[analogUD] setScale:1.5f];*/
            }
        }
		
        if(Rsrc.control_mode == TILT_MODE)
        {
            self.isAccelerometerEnabled = YES;
        }
        
		// speed metor
		speedlabel = [CCLabelTTF labelWithString:@"0km/h" fontName:@"Marker Felt" fontSize:22];
		speedlabel.position =  ccp( size.width/2 , size.height-12 );
		[self addChild: speedlabel z:20];
        
		// score 
		scorelabel = [CCLabelTTF labelWithString:@"Score:0" fontName:@"Marker Felt" fontSize:20];
		scorelabel.position =  ccp( size.width-40 , size.height-12 );
		[self addChild: scorelabel z:20];
        
		// score 
        remain = 3;
		remainlabel = [CCLabelTTF labelWithString:@"Cars:3" fontName:@"Marker Felt" fontSize:20];
		remainlabel.position =  ccp( 28 , size.height-12 );
		[self addChild: remainlabel z:20];
        
        //enable keyboead input
        /*self.isKeyboardEnabled = YES;
         for(int i=0; i<KEYS_NUM; i++){
         keys[i] = NO;
         }*/
        
        //create road image
        {
            roadSpr = [CCSpriteBatchNode batchNodeWithFile:@"CarChaserSprite.png"];
            {
                //道路は縦3枚分の画像を並べる
                for(int i=0; i<3; i++)
                {
                    CCSprite *roadSpr1 = [CCSprite spriteWithFile:@"CarChaserSprite.png" rect:[Rsrc getRoadImageRect]];
                    CGPoint pos = roadSpr1.position;
                    pos.x = 0;
                    pos.y = i*([Rsrc getRoadImageRect].size.height-1);
                    roadSpr1.position = pos;
                    [roadSpr addChild:roadSpr1 z:1 tag:[Rsrc getRoadId:i]];
                }
            }
            
            [self addChild:roadSpr z:1 tag:[Rsrc getRoadId:0]];
            
            CGPoint pos = roadSpr.position;
            pos.x = size.width/2;
            pos.y = 0;
            roadSpr.position = pos;
        }
        
        //create player character
        {
            playerSpr = [CCSprite spriteWithFile:@"CarChaserSprite.png" rect:[Rsrc getCarIconRect:0]];
            [self addChild:playerSpr z:10 tag:[Rsrc getMyCarId]];
            
            CGPoint pos = playerSpr.position;
            pos.x = size.width/2;
            pos.y = Y_CONV(size.height*228/320);
            playerSpr.position = pos;
            [playerSpr setScale:0.6f];
        }
        
        //create enemy character
        for(int i=0; i<ENEMY_NUM; i++){
            enemySpr[i] = [CCSprite spriteWithFile:@"CarChaserSprite.png" rect:[Rsrc getCarIconRect:i+1]];
            [self addChild:enemySpr[i] z:9 tag:[Rsrc getEnemyCarId:i]];
            
            CGPoint pos = enemySpr[i].position;
            pos.x = size.width/2;
            pos.y = Y_CONV(size.height*(-45*i+50)/320);
            enemySpr[i].position = pos;
            [enemySpr[i] setScale:0.6f];
        }
        
        [self scheduleUpdate];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    
    Resources *Rsrc = [Resources getResource];
    if(Rsrc.control_mode == TOUCH_MODE)
    {
        CFRelease(touchesDic); // 解放
    }
    
	[super dealloc];
}


-(void) update:(ccTime)delta
{
    int times = delta/(0.99f/60);
    
    count+=times;
    level += delta;
    
    //制御禁止時間
    if(count<60) {
        for(int i=0;i<BUTTON_NUM; i++){
            [button[i] setOpacity:0x7f];
        }
        controllEnable = NO;
        return;
    }
    else if(controllEnable==NO){
        for(int i=0;i<BUTTON_NUM; i++){
            [button[i] setOpacity:0xff];
        }
        controllEnable = YES;
    }
    
    //コントローラー
    Resources *Rsrc = [Resources getResource];
    if(Rsrc.control_mode==TOUCH_MODE){
        /*for(int i=0; i<BUTTON_NUM; i++){
            if(isTouch[i]){
                [button[i] setScale:1.1f];
            }
            else{
                [button[i] setScale:1.0f];
            }
        }*/
        
        if(controlValue.x < 0){
            [button[0] setScale:1.1f];
        }
        else{
            [button[0] setScale:1.0f];
        }
        if(controlValue.x > 0){
            [button[1] setScale:1.1f];
        }
        else{
            [button[1] setScale:1.0f];
        }
        if(controlValue.y < 0){
            [button[3] setScale:1.1f];
        }
        else{
            [button[3] setScale:1.0f];
        }
        if(controlValue.y > 0){
            [button[2] setScale:1.1f];
        }
        else{
            [button[2] setScale:1.0f];
        }
        
        /*
         analog[analogLR].position = ccp(48+48*controlValue.x,analog[analogLR].position.y);
         analog[analogUD].position = ccp(analog[analogUD].position.x,48+48*controlValue.y);
         */
    }
    
    for(int i=0; i<times; i++){
        [self myGameLoop]; //myGameLoopは必ず1秒間に60回呼ばれる
    }
}

-(void) myGameLoop
{
    Resources *Rsrc = [Resources getResource];
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    //my car
    {
        //reset rotation
        /*if(playerVelocity.x > 0.02){
         playerVelocity.x -= 0.02;
         }else if(playerVelocity.x < -0.02){
         playerVelocity.x += 0.02;
         }
         else*/{
             playerVelocity.x *= 0.95;
         }
        
        if (controlValue.y<-0.2) {
            playerVelocity.x += controlValue.x/1.5;
        }
        else{
            playerVelocity.x += controlValue.x/2.0;
        }
        
        if (controlValue.y>0.0) {
            playerVelocity.y += controlValue.y/8;
        }
        else if (controlValue.y<0.0) {
            playerVelocity.y += controlValue.y/4;
        }
        
        CGPoint pos = playerSpr.position;
        pos.x += 2*playerVelocity.y * sin(playerVelocity.x/10.0);
        pos.y = Y_CONV(size.height*228/320);
        
        pos.y+=controlValue.y*4;
        
        // Keep the player from going outside the screen
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        float imageWidthHalved = [playerSpr texture].contentSize.width * 0.15f;
        float leftBorderLimit = imageWidthHalved;
        float rightBorderLimit = screenSize.width - imageWidthHalved;
        
        //float imageHeightHalved = [playerSpr texture].contentSize.height * 0.1f;
        //float bottomBorderLimit = imageHeightHalved;
        //float topBorderLimit = screenSize.height - imageHeightHalved;
        
        if (pos.x < leftBorderLimit) {
            pos.x = leftBorderLimit+1;
            playerVelocity.y *= 0.99;
        } else if (pos.x > rightBorderLimit) {
            pos.x = rightBorderLimit-1;
            playerVelocity.y *= 0.99;
        }
        
        /*if (pos.y < bottomBorderLimit) {
         pos.y = bottomBorderLimit;
         playerVelocity.y = 0;
         } else if (pos.y > topBorderLimit) {
         pos.y = topBorderLimit;
         playerVelocity.y = 0;
         }*/
        
        playerSpr.position = pos;
        
        [playerSpr setRotation:playerVelocity.x/10.0*180/3.14];
    }
    
    //enemies
    for(int i=0; i<ENEMY_NUM; i++)
    {
        enemyHandle[i].x *= 0.9;
        enemyHandle[i].y *= 0.9;
        enemyVelocity[i].x *= 0.95;
        enemyVelocity[i].y *= 0.99;
        
        if ( random()<RAND_MAX/16 ) {
            enemyHandle[i].x -= 0.15/(abs(enemyVelocity[i].y/3)+3);
        }
        if ( random()<RAND_MAX/16 ) {
            enemyHandle[i].x += 0.15/(abs(enemyVelocity[i].y/3)+3);
        }
        enemyVelocity[i].x += enemyHandle[i].x;
        
        if ( random()<RAND_MAX/16 && enemyHandle[i].y>0.05 ) {
            enemyHandle[i].y -= 0.07;
        }
        
        if ( random()<RAND_MAX/16 ) {
            enemyHandle[i].y += 0.07;
        }
        enemyVelocity[i].y += local_score/300.0 +level/1000.0 +0.01*i;
        enemyVelocity[i].y += enemyHandle[i].y;
        
        CGPoint pos = enemySpr[i].position;
        pos.x += 2*enemyVelocity[i].y*sin(enemyVelocity[i].x/10.0) -(playerVelocity.y * sin(playerVelocity.x/10.0))*0.1;
        pos.y += enemyVelocity[i].y -cos(playerVelocity.x/10.0)*playerVelocity.y;
        
        // Keep the player from going outside the screen
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        float imageWidthHalved = [playerSpr texture].contentSize.width * 0.15f;
        float leftBorderLimit = imageWidthHalved;
        float rightBorderLimit = screenSize.width - imageWidthHalved;
        
        float imageHeightHalved = [playerSpr texture].contentSize.height * 0.0f;
        float bottomBorderLimit = imageHeightHalved;
        float topBorderLimit = screenSize.height - imageHeightHalved;
        
        if (pos.x < leftBorderLimit) {
            pos.x = leftBorderLimit;
            enemyVelocity[i].x = 0;
        } else if (pos.x > rightBorderLimit) {
            pos.x = rightBorderLimit;
            enemyVelocity[i].x = 0;
        }
        
        if (pos.y < bottomBorderLimit-32) {
            pos.y = topBorderLimit+8*i;
            if(playerSpr.position.x<screenSize.width/2){
                //プレイヤーが左にいたら左上から出てくる
                pos.x = leftBorderLimit + random()%(int)(rightBorderLimit-leftBorderLimit)*0.7;
            }
            else{
                //プレイヤーが右にいたら右上から出てくる
                pos.x = leftBorderLimit + random()%(int)(rightBorderLimit-leftBorderLimit)*0.7 
                + (rightBorderLimit-leftBorderLimit)*0.3;
            }
            local_score++;
            score++;
            [scorelabel setString: [NSString stringWithFormat:@"Score:%d",score]];
        } else if (pos.y > topBorderLimit+128) {
            if(bombAnimCount>0){
                pos.y = topBorderLimit+32;
            }
            else
            {
                pos.y = bottomBorderLimit-32;
                if( local_score >-10 ){
                    //後ろに行き続けると出現場所がランダムに
                    pos.x = random()%(int)(rightBorderLimit-leftBorderLimit);                
                }
                else if(playerSpr.position.x>screenSize.width/2){
                    //プレイヤーが右にいたら左下から出てくる
                    pos.x = leftBorderLimit + random()%(int)(rightBorderLimit-leftBorderLimit)/3;
                }
                else{
                    //プレイヤーが左にいたら右下から出てくる
                    pos.x = leftBorderLimit + random()%(int)(rightBorderLimit-leftBorderLimit)/3 
                    + (rightBorderLimit-leftBorderLimit)*2/3;
                }
                local_score--;
                score--;
                [scorelabel setString: [NSString stringWithFormat:@"Score:%d",score]];
            }
        }
        
        enemySpr[i].position = pos;
        [enemySpr[i] setRotation:enemyVelocity[i].x/10.0*180/3.14];
    }
    
    //road scroll
    {
        CGPoint pos = roadSpr.position;
        pos.x = size.width/2 - (playerSpr.position.x-size.width/2)*0.1;
        pos.y -= cos(playerVelocity.x/10.0)*playerVelocity.y;
        
        int roadHeight = [roadSpr getChildByTag:[Rsrc getRoadId:0]].contentSize.height;
        if (pos.y < -roadHeight/2) {
            pos.y += roadHeight-1;
        } else if (pos.y > roadHeight/2) {
            pos.y -= roadHeight-1;
        }
        
        roadSpr.position = pos;
    }
    
    //bomb
    if(bombAnimCount>0){
        //bomb animation
        [playerSpr setDisplayFrame:[Rsrc getBombAnim:1+bombAnimCount/10*2+bombAnimCount/2%2]];
        bombAnimCount++;
        
        for(int i=0; i<ENEMY_NUM; i++){
            if(enemySpr[i].position.x<size.width/2){
                enemyHandle[i].x = -0.4/(enemyVelocity[i].y+1);
                CGPoint pos = enemySpr[i].position;
                pos.x -= 2;
                enemySpr[i].position = pos;
            }
            else {
                enemyHandle[i].x = 0.4/(enemyVelocity[i].y+1);
                CGPoint pos = enemySpr[i].position;
                pos.x += 2;
                enemySpr[i].position = pos;
            }
        }
        
        playerVelocity.y *= 0.95;
        
        if(bombAnimCount >= 40){
            bombAnimCount = 0;
            level = 0;
            
            if(remain==0){
                [self changeToOpening];
                return;
            }
            
            [playerSpr setDisplayFrame:[Rsrc getBombAnim:0]];//car icon
            [playerSpr setScale:0.6f];
            CGPoint pos = playerSpr.position;
            pos.x = size.width/2;
            pos.y = Y_CONV(size.height*228/320);
            playerSpr.position = pos;
            
            playerVelocity.x = 0;
            playerVelocity.y = 0.05;
            
            for(int i=0; i<ENEMY_NUM; i++){
                enemyHandle[i].y = 0;
                enemyVelocity[i].y = 0;
            }
        }
    }
    else{
        //car crash
        for(int i=0; i<ENEMY_NUM; i++){
            if(abs(enemySpr[i].position.x - playerSpr.position.x) < 28 &&
               abs(enemySpr[i].position.y - playerSpr.position.y) < 32)
            {
                remain--;
                [remainlabel setString: [NSString stringWithFormat:@"Cars:%d",remain]];
                level = 0.0;
                CGPoint pos = enemySpr[i].position;
                pos.y = Y_CONV(size.height*-32/320);
                enemySpr[i].position = pos;
                enemyHandle[i].y = 0;
                
                for(int j=0; j<ENEMY_NUM; j++){
                    enemyVelocity[j].x = 0;
                }
                
                //animation
                [playerSpr setDisplayFrame:[Rsrc getBombAnim:1]];
                [playerSpr setScale:1.2f];
                bombAnimCount = 1;
                
                //high score
                {
                    if(Rsrc.highscore < score){
                        Rsrc.highscore = score;
                    }
                    [Rsrc syncHighScore];
                }
                
                local_score = 0;
            }
        }
    }
    
    //enemy car collision
    for(int i=0; i<ENEMY_NUM-1; i++){
        for(int j=i+1; j<ENEMY_NUM; j++){
            float ix = enemySpr[i].position.x+5*2*sin(enemyVelocity[i].x/10)*enemyVelocity[j].y;
            float iy = enemySpr[i].position.y+5*enemyVelocity[i].y;
            float jx = enemySpr[j].position.x+5*2*sin(enemyVelocity[j].x/10)*enemyVelocity[j].y;
            float jy = enemySpr[j].position.y+5*enemyVelocity[j].y;
            if(abs(ix - jx) < 40 &&
               abs(iy - jy) < 44)
            {
                if(abs(ix - jx) <
                   abs(iy - jy) )
                {
                    if(ix < jx){
                        enemyVelocity[i].x -= 0.15;
                        enemyVelocity[j].x += 0.15;
                    }
                    else{
                        enemyVelocity[i].x += 0.15;
                        enemyVelocity[j].x -= 0.15;
                    }
                }else{
                    if(iy < jy){
                        enemyVelocity[i].y -= 0.15;
                        enemyVelocity[j].y += 0.15;
                    }
                    else{
                        enemyVelocity[i].y += 0.15;
                        enemyVelocity[j].y -= 0.15;
                    }
                }
            }
        }
    }
    
    //speed metor
    if(count%10 == 0){ //1秒に6回更新
        [speedlabel setString: [NSString stringWithFormat:@"%0.0fkm/h",playerVelocity.y*10.0]];
    }
    
    //high speed
    if(thisgame_highspeed < playerVelocity.y){
        thisgame_highspeed = playerVelocity.y;
        if(Rsrc.highspeed < playerVelocity.y){
            Rsrc.highspeed = playerVelocity.y;
        }
    }
}


//タッチの開始
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView: [touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToUI:location]; // 座標を扱う場合はここの変換を忘れないようにしないと。
        
        //LR
        {
            CGPoint LRPosition = button[LeftButton].position;
            if(convertedLocation.x < button[LeftButton].position.x){
            }
            else if(convertedLocation.x > button[RightButton].position.x){
                LRPosition = button[RightButton].position;
            }else{
                LRPosition.x = convertedLocation.x;
            }
            float distance = ccpDistance(convertedLocation, LRPosition);
            if(distance<button[LeftButton].contentSize.width*1.2){
                float LRDistance = button[RightButton].position.x - button[LeftButton].position.x;
                controlValue.x = (convertedLocation.x-(button[LeftButton].position.x+button[RightButton].position.x)/2)/LRDistance;
                if(controlValue.x < -0.5){
                    controlValue.x = -0.5;
                }
                if(controlValue.x > 0.5){
                    controlValue.x = 0.5;
                }
                
                NSNumber *nsi = [NSNumber numberWithInt:analogLR];
                CFDictionarySetValue(touchesDic, touch, nsi); // 辞書に追加
            }
        }
        
        //UD
        CGPoint UDPosition = button[BlakeButton].position;
        if(convertedLocation.y < button[BlakeButton].position.y){
        }
        else if(convertedLocation.y > button[JumpButton].position.y){
            UDPosition = button[JumpButton].position;
        }else{
            UDPosition.y = convertedLocation.y;
        }
        float distance = ccpDistance(convertedLocation, UDPosition);
        if(distance<button[BlakeButton].contentSize.width*1.2){
            float UDDistance = button[JumpButton].position.y - button[BlakeButton].position.y;
            controlValue.y = (convertedLocation.y-(button[BlakeButton].position.y+button[JumpButton].position.y)/2)/UDDistance;
            if(controlValue.y < -0.5){
                controlValue.y = -0.5;
            }
            if(controlValue.y > 0.5){
                controlValue.y = 0.5;
            }
            
            NSNumber *nsi = [NSNumber numberWithInt:analogUD];
            CFDictionarySetValue(touchesDic, touch, nsi); // 辞書に追加
        }
    }
}

//タッチの移動
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView: [touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToUI:location]; // 座標を扱う場合はここの変換を忘れないようにしないと。
        
        //LR
        {
            CGPoint LRPosition = button[LeftButton].position;
            if(convertedLocation.x < button[LeftButton].position.x){
            }
            else if(convertedLocation.x > button[RightButton].position.x){
                LRPosition = button[RightButton].position;
            }else{
                LRPosition.x = convertedLocation.x;
            }
            float distance = ccpDistance(convertedLocation, LRPosition);
            if(distance<button[LeftButton].contentSize.width*1.2){
                float LRDistance = button[RightButton].position.x - button[LeftButton].position.x;
                controlValue.x = (convertedLocation.x-(button[LeftButton].position.x+button[RightButton].position.x)/2)/LRDistance;
                if(controlValue.x < -0.5){
                    controlValue.x = -0.5;
                }
                if(controlValue.x > 0.5){
                    controlValue.x = 0.5;
                }
                
                NSNumber *nsi = [NSNumber numberWithInt:analogLR];
                CFDictionarySetValue(touchesDic, touch, nsi); // 辞書の値を変更
                continue;
            }
        }
        
        //UD
        {
            CGPoint UDPosition = button[BlakeButton].position;
            if(convertedLocation.y < button[BlakeButton].position.y){
            }
            else if(convertedLocation.y > button[JumpButton].position.y){
                UDPosition = button[JumpButton].position;
            }else{
                UDPosition.y = convertedLocation.y;
            }
            float distance = ccpDistance(convertedLocation, UDPosition);
            if(distance<button[BlakeButton].contentSize.width*1.2){
                float UDDistance = button[JumpButton].position.y - button[BlakeButton].position.y;
                controlValue.y = (convertedLocation.y-(button[BlakeButton].position.y+button[JumpButton].position.y)/2)/UDDistance;
                if(controlValue.y < -0.5){
                    controlValue.y = -0.5;
                }
                if(controlValue.y > 0.5){
                    controlValue.y = 0.5;
                }
                
                NSNumber *nsi = [NSNumber numberWithInt:analogUD];
                CFDictionarySetValue(touchesDic, touch, nsi); // 辞書の値を変更/追加
                continue;
            }
        }
        
        //ボタン範囲外
        NSNumber *nsi = (NSNumber *)CFDictionaryGetValue(touchesDic, touch);
        if(nsi!=nil){
            if(nsi.intValue==analogLR){
                controlValue.x = 0;
            }
            if(nsi.intValue==analogUD){
                controlValue.y = 0;
            }
            CFDictionaryRemoveValue(touchesDic, touch); // 削除
        }
    }
}

//タッチの終了
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        NSNumber *nsi = (NSNumber *)CFDictionaryGetValue(touchesDic, touch);
        if(nsi!=nil){
            if(nsi.intValue==analogLR){
                controlValue.x = 0;
            }
            if(nsi.intValue==analogUD){
                controlValue.y = 0;
            }
        }
        
        CFDictionaryRemoveValue(touchesDic, touch); // 削除
    }
}

//タッチのキャンセル=終了
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self ccTouchesEnded:touches withEvent:event];
}


//デジタルタッチパッド
/*
 //タッチの開始
 - (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
 // UITouch *touch = [touches anyObject]; //シングルタッチ用
 
 for (UITouch *touch in touches)
 {
 CGPoint location = [touch locationInView: [touch view]];
 CGPoint convertedLocation = [[CCDirector sharedDirector] convertToUI:location]; // 座標を扱う場合はここの変換を忘れないようにしないと。
 
 for(int i=0; i<BUTTON_NUM; i++){
 float distance = ccpDistance(convertedLocation, button[i].position);
 
 if(distance<button[i].contentSize.width){
 isTouch[i] = YES;
 
 NSNumber *nsi = [NSNumber numberWithInt:i];
 CFDictionarySetValue(touchesDic, touch, nsi); // 辞書に追加
 }
 }
 
 }
 }
 
 //タッチの移動
 - (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
 {
 // UITouch *touch = [touches anyObject]; //シングルタッチ用
 
 
 for (UITouch *touch in touches)
 {
 CGPoint location = [touch locationInView: [touch view]];
 CGPoint convertedLocation = [[CCDirector sharedDirector] convertToUI:location]; // 座標を扱う場合はここの変換を忘れないようにしないと。
 
 for(int i=0; i<BUTTON_NUM; i++){
 float distance = ccpDistance(convertedLocation, button[i].position);
 
 if(distance<button[i].contentSize.width){
 NSNumber *nsi = (NSNumber *)CFDictionaryGetValue(touchesDic, touch);
 if(nsi == nil || nsi.intValue != i){
 //新たに押されたか、場所が変わった
 if(nsi!=nil){
 isTouch[nsi.intValue] = NO;
 }
 isTouch[i] = YES;
 if(i==LeftButton) isTouch[RightButton] = NO;
 if(i==RightButton) isTouch[LeftButton] = NO;
 
 NSNumber *nsi2 = [NSNumber numberWithInt:i];
 CFDictionarySetValue(touchesDic, touch, nsi2); // 辞書の値を変更/辞書に無ければ追加
 }
 }
 }
 }
 }
 
 //タッチの終了
 - (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 {
 // UITouch *touch = [touches anyObject]; //シングルタッチ用
 
 for (UITouch *touch in touches)
 {
 //CGPoint location = [touch locationInView: [touch view]];
 //CGPoint convertedLocation = [[CCDirector sharedDirector] convertToUI:location]; // 座標を扱う場合はここの変換を忘れないようにしないと。
 //
 //for(int i=0; i<BUTTON_NUM; i++){
 //    float distance = ccpDistance(convertedLocation, button[i].position);
 //    
 //    if(distance<button[i].contentSize.width){
 //        isTouch[i] = NO;
 //    }
 //}
 
 NSNumber *nsi = (NSNumber *)CFDictionaryGetValue(touchesDic, touch);
 if(nsi!=nil){
 isTouch[nsi.intValue] = NO;
 }
 
 CFDictionaryRemoveValue(touchesDic, touch); // 削除
 }
 }
 
 //タッチのキャンセル=終了
 - (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
 {
 [self ccTouchesEnded:touches withEvent:event];
 }
 */


//加速度センサー
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    Resources *Rsrc = [Resources getResource];
    
    controlValue.x = acceleration.x;
    if(controlValue.x<-0.5){
        controlValue.x = -0.5;
    }
    if(controlValue.x>0.5){
        controlValue.x = 0.5;
    }
    
    float center_y = [Rsrc getAccelometer]-0.05;
    if(center_y<-0.6) center_y = -0.6;
    if(center_y>0.1) center_y = 0.1;
    controlValue.y = (acceleration.y-center_y)*1.2 ;
    if(controlValue.y<-0.5){
        controlValue.y = -0.5;
    }
    if(controlValue.y>0.5){
        controlValue.y = 0.5;
    }
    
    
    /*if(acceleration.x < -0.2){
     isTouch[LeftButton] = YES;
     }else{
     isTouch[LeftButton] = NO;
     }
     
     if(acceleration.x > 0.2){
     isTouch[RightButton] = YES;
     }else{
     isTouch[RightButton] = NO;
     }
     
     if(acceleration.y > -0.2){
     isTouch[JumpButton] = YES;
     }else{
     isTouch[JumpButton] = NO;
     }
     
     if(acceleration.y < -0.6){
     isTouch[BlakeButton] = YES;
     }else{
     isTouch[BlakeButton] = NO;
     }*/
}


-(void) changeToOpening
{
    Resources *Rsrc = [Resources getResource];
    [Rsrc gameCenterSubmit:score highspeed:thisgame_highspeed];
    
    CCTransitionRadialCCW *tran = [CCTransitionRadialCCW transitionWithDuration:1 scene:[OpeningLayer scene]];
    [[CCDirector sharedDirector] replaceScene:tran];
}

@end
