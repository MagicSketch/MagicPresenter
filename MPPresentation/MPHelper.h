//
//  MPHelper.h
//  MagicPresenter
//
//  Created by james on 17/5/2016.
//  Copyright © 2016年 MagicSketch. All rights reserved.
//

#ifndef MPHelper_h
#define MPHelper_h

#if DEBUG
#define DLog(format, ...) NSLog((format), ## __VA_ARGS__)
#else
#define DLog(format, ...)
#endif


#endif /* MPHelper_h */
