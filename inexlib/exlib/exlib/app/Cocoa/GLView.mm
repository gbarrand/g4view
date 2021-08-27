// Copyright (C) 2010, Guy Barrand. All rights reserved.
// See the file exlib.license for terms.

#import "GLView.hm"

@implementation GLView
- (id)initWithFrame:(NSRect)a_rect {
  NSOpenGLPixelFormatAttribute att[32];
  int i = 0;
  att[i++] = NSOpenGLPFADoubleBuffer;
  att[i++] = NSOpenGLPFAAccelerated;
  att[i++] = NSOpenGLPFAAccumSize;
  att[i++] = (NSOpenGLPixelFormatAttribute)32;
  att[i++] = NSOpenGLPFAColorSize;
  att[i++] = (NSOpenGLPixelFormatAttribute)32;
  att[i++] = NSOpenGLPFADepthSize;
  att[i++] = (NSOpenGLPixelFormatAttribute)32;

  // Antialiasing :
  att[i++] = NSOpenGLPFASampleBuffers;
  att[i++] = 1;
  att[i++] = NSOpenGLPFASamples;
  att[i++] = 2;
  att[i++] = NSOpenGLPFANoRecovery;

  att[i] = (NSOpenGLPixelFormatAttribute)0;
  NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:att];

  if (self = [super initWithFrame:a_rect pixelFormat:pixelFormat]) {
    // flush buffer only during the vertical retrace of the monitor
    const GLint vals[1] = {1};
#if MAC_OS_X_VERSION_MAX_ALLOWED < 1014
    [[self openGLContext] setValues:vals forParameter:NSOpenGLCPSwapInterval];
#else
    [[self openGLContext] setValues:vals forParameter:NSOpenGLContextParameterSwapInterval];
#endif
  }

  [pixelFormat release];

  NSTrackingAreaOptions _options = NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect;
  NSTrackingArea* tracking_area =
    [[NSTrackingArea alloc] initWithRect:NSZeroRect
				 options:_options
				   owner:self userInfo:nil];
  [self addTrackingArea:tracking_area];

  m_main = 0;
  m_cursor_default = [NSCursor arrowCursor];
  m_cursor_target = [NSCursor crosshairCursor];
  m_cursor_current = m_cursor_default;

  return self;
}
- (void)dealloc {[super dealloc];}

/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////

- (void)drawRect:(NSRect)a_rect {
  [[self openGLContext] makeCurrentContext];

#if MAC_OS_X_VERSION_MAX_ALLOWED < 101500
  int w = a_rect.size.width;
  int h = a_rect.size.height;
#else
  NSRect backing_rect = [self convertRectToBacking:a_rect];
  int w  = (int)(backing_rect.size.width);
  int h = (int)(backing_rect.size.height);
#endif

  if(m_main) {
    m_main->set_size(w,h);
    m_main->render();
  }

  [[self openGLContext] flushBuffer];
}
- (void)mouseDown:(NSEvent*)a_event {
  [super mouseDown:a_event];
#if MAC_OS_X_VERSION_MAX_ALLOWED < 101500
  NSPoint p = [a_event locationInWindow];
#else
  NSPoint _p = [a_event locationInWindow];
  NSPoint p = [self convertPointToBacking:_p];
#endif
  //(0,0) = bottom left of window.
  //NSLog(@"debug : GLView::mouseDown %g %g",p.x,p.y);
  if(m_main) {
    if(m_main->touch_down(p.x,p.y)) m_main->win_render();
    //if(m_main->num_cbks()) {
      //[m_app_delegate start_work_timer];
    //}
  }
}

- (void)mouseUp:(NSEvent*)a_event {
  [super mouseUp:a_event];
#if MAC_OS_X_VERSION_MAX_ALLOWED < 101500
  NSPoint p = [a_event locationInWindow];
#else
  NSPoint _p = [a_event locationInWindow];
  NSPoint p = [self convertPointToBacking:_p];
#endif
  //(0,0) = bottom left of window.
  //NSLog(@"debug : GLView::mouseUp %g %g",p.x,p.y);
  if(m_main) {
    m_main->add_work_check_arm_buttons();
    if(m_main->touch_up(p.x,p.y)) m_main->win_render();
    //if(m_main->num_cbks()) {
      //[m_app_delegate start_work_timer];
    //}
  }
}

- (void)mouseDragged:(NSEvent*)a_event {
  [super mouseDragged:a_event];
#if MAC_OS_X_VERSION_MAX_ALLOWED < 101500
  NSPoint p = [a_event locationInWindow];
#else
  NSPoint _p = [a_event locationInWindow];
  NSPoint p = [self convertPointToBacking:_p];
#endif
  //(0,0) = bottom left of window.
  //NSLog(@"debug : GLView::mouseDragged %g %g",p.x,p.y);
  if(m_main) {
    if(m_main->touch_move(p.x,p.y)) m_main->win_render();
  }
}

- (void)mouseEntered:(NSEvent*)a_event {
  //NSLog(@"debug : mouseEntered");
  [super mouseEntered:a_event];
  [m_cursor_current set];
}

- (void)resetCursorRects {
  [super resetCursorRects];
  [self discardCursorRects];
  [self addCursorRect:self.bounds cursor:m_cursor_default];
  [self addCursorRect:self.bounds cursor:m_cursor_target];
  [m_cursor_current set];
}

- (BOOL)acceptsFirstResponder {return YES;} //so that keyDown be called.

- (void)keyDown:(NSEvent*)a_event {
  [super keyDown:a_event];
  //NSLog(@"debug : GLView::keyDown");

  if(!m_main) return;

  bool shift = [a_event modifierFlags] & NSShiftKeyMask;
  bool ctrl = [a_event modifierFlags] & NSControlKeyMask;

  //NSString* chars = [a_event charactersIgnoringModifiers];
  NSString* chars = [a_event characters];
  if ( [chars length] == 0 ) return;
  if ( [chars length] != 1 ) {[super keyDown:a_event];return;}

  unichar keyChar = [chars characterAtIndex:0];

  if ( keyChar == NSLeftArrowFunctionKey ) {
    if(m_main->do_key(inlib::sg::key_left,shift,ctrl))
      m_main->win_render();
  } else if ( keyChar == NSRightArrowFunctionKey ) {
    if(m_main->do_key(inlib::sg::key_right,shift,ctrl))
      m_main->win_render();
  } else if ( keyChar == NSUpArrowFunctionKey ) {
    if(m_main->do_key(inlib::sg::key_up,shift,ctrl))
      m_main->win_render();
  } else if ( keyChar == NSDownArrowFunctionKey ) {
    if(m_main->do_key(inlib::sg::key_down,shift,ctrl))
      m_main->win_render();

  } else if ( keyChar == NSTabCharacter ) {
    if(m_main->do_tab(false)) m_main->win_render();
  } else if ( keyChar == 25 ) { //shift+tab ! //ASCII 25=EM (end of medium)
    if(m_main->do_tab(true)) m_main->win_render();
  } else if ( keyChar == NSCarriageReturnCharacter ) {
    m_main->do_return();
    //if(m_main->num_cbks()) [m_app_delegate start_work_timer];
  } else if ( keyChar == 27 ) { //escape
    m_main->do_escape();
    m_main->win_render();
  }
  //NSLog(@"debug : GLView::keyDown : ??? %d \"%c\"",keyChar,keyChar);
}

/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
- (void)set_main:(app_main_t*)a_main{m_main = a_main;}
- (void)set_cursor:(inlib::sg::cursor_shape)a_cursor {
  if(a_cursor==inlib::sg::cursor_default) {
    [m_cursor_default set];
    m_cursor_current = m_cursor_default;
  } else if(a_cursor==inlib::sg::cursor_target) {
    [m_cursor_target set];
    m_cursor_current = m_cursor_target;
  }
}

@end

// skip because of app_main_t.
//exlib_build_use skip
