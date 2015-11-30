//
//  DLog.h
//  iWinvest3
//
//  Created by admin on 10/02/2011.
//  Copyright 2011 Transaction Technologies Limited. All rights reserved.
//

#ifdef DEBUG
    #ifndef DLog
        #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    #endif
#else
    #ifndef DLog
        #define DLog(...) {}
    #endif
#endif
