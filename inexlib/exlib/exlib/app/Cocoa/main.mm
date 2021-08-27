// Copyright (C) 2010, Guy Barrand. All rights reserved.
// See the file exlib.license for terms.

#import "main.hm"

#include "../../Cocoa/NSLog_streambuf.hm"

// for a full screen window to receive keyboard events.
@interface FSWindow : NSWindow {}
- (BOOL)canBecomeKeyWindow;
@end
@implementation FSWindow
- (BOOL)canBecomeKeyWindow {return YES;}
@end

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
#ifdef EXLIB_APP_HAS_TERM
#include <Getline/ourex_Getline.h>
#endif

#include "sg_serv.hm"

#if MAC_OS_X_VERSION_MAX_ALLOWED <= 1050
@interface app_delegate : NSObject {
#else
@interface app_delegate : NSObject<NSApplicationDelegate> {
#endif
  app_main_t* m_main;
}
- (id)init:(app_main_t*)a_main;
- (void)dealloc;
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication*)a_app;
- (BOOL)application:(NSApplication*)a_app openFile:(NSString*)a_file;
@end
@implementation app_delegate
- (id)init:(app_main_t*)a_main {
  m_main = 0;
  if(self = [super init]) {
    m_main = a_main;
  }
  return self;
}
- (void)dealloc {
  [super dealloc];
}
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication*)a_app {
  m_main->clear_tmp();
#ifdef EXLIB_APP_HAS_TERM
  ::ourex_Gl_erase_line();
  ::ourex_Getlinem(2,0);
#endif
  (void)a_app;
  return NSTerminateNow;
}
- (BOOL)application:(NSApplication*)a_app openFile:(NSString*)a_file {
  //NSLog(@"debug : open : %@\n",a_file);
  if(!m_main) return NO;
  std::string document = [a_file UTF8String];

  bool done;
  if(!m_main->opener().open(document,inlib::file::s_format_guessed(),inlib::args(),done)) {}
  if(!done) {}

  m_main->win_render();
  (void)a_app;
  return YES;
}
@end

#if MAC_OS_X_VERSION_MAX_ALLOWED <= 1050
@interface win_delegate : NSObject {
#else
@interface win_delegate : NSObject<NSWindowDelegate> {
#endif
  app_main_t* m_main;
  inlib::net::sg_serv* m_sg_serv;
  NSFileHandle* m_sg_serv_file_handle;
  NSFileHandle* m_sg_client_file_handle;
}
- (id)init:(app_main_t*)a_main sg_serv:(inlib::net::sg_serv*)a_sg_serv;
- (void)dealloc;
- (void)windowWillClose:(NSNotification*)a_not;
- (NSFileHandle*)add_fh:(int)a_id selector:(SEL)a_selector;
- (void)remove_fh:(NSFileHandle*)a_fh;
- (void)sg_client_fh_callback:(NSNotification*)a_not;
- (void)sg_serv_fh_callback:(NSNotification*)a_not;
- (void)remove_sg_serv_file_handle;
- (void)set_sg_client_file_handle:(NSFileHandle*)a_sg_client_file_handle;
- (NSFileHandle*)get_sg_client_file_handle;
- (void)get_nsevent:(NSApplication*)a_app blocking:(bool)a_blocking;
@end
@implementation win_delegate
- (id)init:(app_main_t*)a_main sg_serv:(inlib::net::sg_serv*)a_sg_serv {
  m_main = 0;
  m_sg_serv = 0;
  m_sg_serv_file_handle = 0;
  m_sg_client_file_handle = 0;
  if(self = [super init]) {
    m_main = a_main;
    m_sg_serv = a_sg_serv;
  }
  return self;
}
- (void)dealloc {
  if(m_sg_serv_file_handle) {
    [self remove_fh:m_sg_serv_file_handle];
    m_sg_serv_file_handle = 0;
  }
  if(m_sg_client_file_handle) {
    [self remove_fh:m_sg_client_file_handle];
    m_sg_client_file_handle = 0;
  }
  [super dealloc];
}
- (void)windowWillClose:(NSNotification*)a_not {
  //NSLog(@"debug : win_delegate::windowWillClose");
  m_main->set_to_exit();
  (void)a_not;
}
- (NSFileHandle*)add_fh:(int)a_id selector:(SEL)a_selector {
  //NSLog(@"debug : add_fh : socket %d",a_id);
  NSFileHandle* fh = [[NSFileHandle alloc] initWithFileDescriptor:a_id];
  [fh waitForDataInBackgroundAndNotify];
  [[NSNotificationCenter defaultCenter] addObserver:self
     selector:a_selector name:NSFileHandleDataAvailableNotification object:fh];
  return fh;
}
- (void)remove_fh:(NSFileHandle*)a_fh {
  [[NSNotificationCenter defaultCenter]
    removeObserver:self name:NSFileHandleDataAvailableNotification object:a_fh];
}
- (void)sg_client_fh_callback:(NSNotification*)a_not {
  NSFileHandle* fh = (NSFileHandle*)[a_not object];
  if(!fh) return;

  //NSLog(@"debug : win_delegate::sg_client_fh_callback");

  inlib::sg::view_sg_client* _view_sg_client = inlib::sg::cast_view_sg_client(*m_main);

  if(!_view_sg_client->poll()) {}
  if(!_view_sg_client->is_connected()) {
    //we have received a inlib::wall::protocol::disconnect()
    m_main->map_warn("disconnected");
    m_main->win_render();
    [self remove_fh:fh];
    m_sg_client_file_handle = 0;
    return;
  }

  //exlib::post_event(m_window,EXLIB_NSEVENT_FILE_HANDLE); //Hmmm, it is needed in wall/Cocoa/master.mm.

  [fh waitForDataInBackgroundAndNotify];
}
- (void)sg_serv_fh_callback:(NSNotification*)a_not {
  NSFileHandle* fh = (NSFileHandle*)[a_not object];
  if(!fh) return;

  //NSLog(@"debug : win_delegate::sg_serv_fh_callback");

  inlib::sg::view_sg_serv* _view_sg_serv = inlib::sg::cast_view_sg_serv(*m_main);

  if(!_view_sg_serv->treat_event(exlib::decompress_buffer)) {
    NSLog(@"win_delegate::sg_serv_fh_callback : view_sg_serv::treat_event() failed.");
    m_main->map_warn("view_sg_serv : treat_event() failed.");
    m_main->win_render();
  }

  //exlib::post_event(m_window,EXLIB_NSEVENT_FILE_HANDLE); //Hmmm, it is needed in wall/Cocoa/master.mm.

  [fh waitForDataInBackgroundAndNotify];
}
- (void)remove_sg_serv_file_handle {
  if(m_sg_serv_file_handle) {
    [self remove_fh:m_sg_serv_file_handle];
    m_sg_serv_file_handle = 0;
  }
}
- (void)set_sg_client_file_handle:(NSFileHandle*)a_sg_client_file_handle {
  m_sg_client_file_handle = a_sg_client_file_handle;
}
- (NSFileHandle*)get_sg_client_file_handle {return m_sg_client_file_handle;}
- (void)get_nsevent:(NSApplication*)a_app blocking:(bool)a_blocking {
  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
//#if MAC_OS_X_VERSION_MAX_ALLOWED < 1012
#if MAC_OS_X_VERSION_MAX_ALLOWED <= 1060   //macarts.
  NSEvent* event = [a_app nextEventMatchingMask:NSAnyEventMask
#else
  NSEvent* event = [a_app nextEventMatchingMask:NSEventMaskAny
#endif
                                      untilDate:a_blocking ? [NSDate distantFuture] : [NSDate distantPast]
                                         inMode:NSDefaultRunLoopMode
                                        dequeue:YES];
  if(event) {
    //NSLog(@"debug : loop : event %d",[event type]);
//#if MAC_OS_X_VERSION_MAX_ALLOWED < 1012
#if MAC_OS_X_VERSION_MAX_ALLOWED <= 1060   //macarts.
    if([event type]==NSApplicationDefined) {
#else
    if([event type]==NSEventTypeApplicationDefined) {
#endif
      if([event subtype]==EXLIB_NSEVENT_CONNECT) {
        if(m_sg_serv) {
	  if(m_sg_serv_file_handle) {
            NSLog(@"win_delegate::get_nsevent : EXLIB_NSEVENT_CONNECT : WARNING : m_sg_serv_file_handle not null !");
	  } else {
            m_sg_serv_file_handle =
             [self add_fh:m_sg_serv->sg_client_sock().socket() selector:@selector(sg_serv_fh_callback:)];
	  }
	}
      } else if([event subtype]==EXLIB_NSEVENT_DISCONNECT) {
        if(m_sg_serv) {
	  if(!m_sg_serv_file_handle) {
            NSLog(@"win_delegate::get_nsevent : EXLIB_NSEVENT_DISCONNECT : WARNING : m_sg_serv_file_handle is null !");
	  } else {
            [self remove_fh:m_sg_serv_file_handle];
            m_sg_serv_file_handle = 0;
	  }
	}
      }
    } else {
      [a_app sendEvent:event];
      [a_app updateWindows];
    }
  }
  [pool release];
}
@end

#ifdef EXLIB_APP_HAS_TERM
#ifdef EXLIB_APP_TERM_INSH
#include "../../insh_term_timer"
#else
#include "../../dummy_term_timer"
#endif
#else
#include <inlib/sys/base_timer>
#endif

#include <inlib/sg/view_sg_client>
template <class APP_MAIN>
inline void sg_client_start_func(void* a_win_delegate,void* a_main){
  win_delegate* _win_delegate = (win_delegate*)a_win_delegate;
  app_Cocoa::main<APP_MAIN>* _main = (app_Cocoa::main<APP_MAIN>*)a_main;
  if(_main->verbose()) _main->out() << "sg_client_start_func : begin :" << std::endl;
  NSFileHandle* fh = [_win_delegate get_sg_client_file_handle];
  if(fh) {
    NSLog(@"sg_client_start_func : WARNING : sg_client_file_handle is not null !");
  } else {
    inlib::sg::view_sg_client* _view_sg_client = inlib::sg::cast_view_sg_client(*_main);
    if(!_view_sg_client->is_connected()) {
      NSLog(@"sg_client_start_func : WARNING : no socket.");
    } else {
      NSFileHandle* fh = [_win_delegate add_fh:_view_sg_client->socket() selector:@selector(sg_client_fh_callback:)];
      [_win_delegate set_sg_client_file_handle:fh];
    }
  }
  if(_main->verbose()) _main->out() << "sg_client_start_func : end." << std::endl;
}
template <class APP_MAIN>
inline void sg_client_stop_func(void* a_win_delegate,void* a_main){
  // called from main => view_sg_client dstors.
  win_delegate* _win_delegate = (win_delegate*)a_win_delegate;
  app_Cocoa::main<APP_MAIN>* _main = (app_Cocoa::main<APP_MAIN>*)a_main;
  if(_main->verbose()) _main->out() << "sg_client_stop_func : begin :" << std::endl;
  inlib::sg::view_sg_client* _view_sg_client = inlib::sg::cast_view_sg_client(*_main);
 {NSFileHandle* fh = [_win_delegate get_sg_client_file_handle];
  if(!fh) {
    NSLog(@"sg_client_stop_func : WARNING : sg_client_file_handle is null !");
  } else {
    [_win_delegate remove_fh:fh];
    [_win_delegate set_sg_client_file_handle:0];
    _main->map_warn("disconnected");
    _main->win_render();
  }}
  if(_main->verbose()) _main->out() << "sg_client_stop_func : end." << std::endl;
}


#include <inlib/sg/view_sg_serv>

inline void sg_serv_finalize_func(void* a_window,void*){
  //NSLog(@"debug : sg_serv_finalize_func.");
  NSWindow* _window = (NSWindow*)a_window;
  win_delegate* _win_delegate = [_window delegate];
  [_win_delegate remove_sg_serv_file_handle];
}

#ifdef INLIB_MEM
#include <inlib/mem>
#ifdef INLIB_MEM_ATEXIT

#ifdef EXLIB_APP_HAS_TERM
#include <iostream>
inline void at_exit() {std::cout << "exlib_main : at_exit..."<< std::endl;inlib::mem::balance(std::cout);}
#else
inline void at_exit() {
  NSLog(@"exlib_main : atexit...");
  NSLog_streambuf nsbuf;
  std::ostream nsout(&nsbuf);
  inlib::mem::balance(nsout);
}
#endif //EXLIB_APP_HAS_TERM

#endif //INLIB_MEM_ATEXIT
#endif //INLIB_MEM

#include <inlib/sargs>
#include <inlib/app>
#include <inlib/saui>

#ifdef EXLIB_APP_HAS_TERM
#include <iostream>
#endif

#include <cstdlib>

template <class APP_MAIN>
inline int exlib_main(const std::string& a_app_name,int argc, char** argv) {
  bool verbose = false;

  //NSLog(@"debug : exlib_main : 006");

#ifdef EXLIB_APP_HAS_TERM
  std::ostream& nsout = std::cout;
#else
  NSLog_streambuf nsbuf;
  std::ostream nsout(&nsbuf);
#endif

#ifdef INLIB_MEM
  #ifdef INLIB_MEM_ATEXIT
  ::atexit(at_exit);
  #endif
  inlib::mem::set_check_by_class(true);{
#endif

  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////

  NSAutoreleasePool* main_pool = [[NSAutoreleasePool alloc] init];

  NSApplication* app = [NSApplication sharedApplication];

  NSString* ns = [[NSString alloc] initWithString:@"MainMenu"];
#if MAC_OS_X_VERSION_MAX_ALLOWED <= 1070
  BOOL status = [NSBundle loadNibNamed:ns owner:app];
#else
  BOOL status = [[NSBundle mainBundle] loadNibNamed:ns owner:app topLevelObjects:NULL];
#endif
  if(!status) {
    NSLog(@"load MainMenu nib failed.");
  }
  [ns release];

  //NOTE : with open, we can pass args with : --args <args>
  inlib::args args(argc,argv);

  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  if(args.is_arg(inlib::s_arg_h())||args.is_arg(inlib::s_arg_help())) {
    nsout << "\
usage :\n\
  macOS> <exe> [options] <file>\n\
options are :\n\
-h, -help           : dump this message.\n\
-verbose            : verbose mode.\n\
-version            : dump the version of the application.\n\
-ww=<window width>  : if -wh is not given, wh is computed to have a A4 landscape ratio.\n\
-wh=<window height> : if -ww is not given, ww is computed to have a A4 landscape ratio.\n\
-portrait           : if needed, swap ww and wh to be in portrait mode.\n\
-land               : if needed, swap ww and wh to be in landscape mode.\n\
-full_screen        : to be full screen.\n\
-no_decos           : to remove window decorations.\n\
-black              : start with a black backgroud for the viewing area.\n\
-arg0               : print argv[0].\n\
";
    //-monitors           : dump the number of monitors known by the X11 server.
#ifdef EXLIB_APP_HAS_TERM
#ifdef EXLIB_APP_TERM_INSH
    nsout << "\
-terminal           : have an insh prompt in the terminal.\n\
";
#endif
#endif
    nsout << APP_MAIN::s_args_help();
    return EXIT_FAILURE;
  }
  if(args.is_arg(inlib::s_arg_version())) {
    nsout << APP_MAIN::s_version() << std::endl;
    return EXIT_FAILURE;
  }
  if(args.is_arg(inlib::s_arg_arg0())) {
    nsout << (argc?argv[0]:"none") << std::endl;
    return EXIT_FAILURE;
  }
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////

  verbose = args.is_arg("-verbose");

  unsigned int ww,wh;
  inlib::window_size_from_args(args,ww,wh);

  unsigned int monitor = 0;
  bool full_screen = args.is_arg(inlib::s_arg_full_screen());
  unsigned int window_x = 0;
  unsigned int window_y = 0;
  unsigned int window_width = ww;
  unsigned int window_height = wh;
  //std::string document;

  NSScreen* screen = 0;
 {NSArray* scrs = [NSScreen screens];
  int number = [scrs count];
  //NSLog(@"debug : screens %d",number);
  if(int(monitor)<number) {
    screen = (NSScreen*)[scrs objectAtIndex:monitor];
   //NSLog(@"debug : screen %d %lu",monitor,(NSScreen*)[scrs objectAtIndex:0]);
  }}

  NSRect screen_rect = [screen frame];
  //NSLog(@"debug : screen : %g %g %g %g",
  //  rect.origin.x,rect.origin.y,
  //  rect.size.width,rect.size.height);}

  // Create window :
  // origin = bottom, left.
  NSRect rect;
  if(full_screen) {
    rect = [screen frame];
    rect.origin.x = 0;
    rect.origin.y = 0;
  } else {
    rect.origin.x = window_x;
    rect.origin.y = screen_rect.size.height-(window_y+window_height),
    rect.size.width = window_width;
    rect.size.height = window_height;
    if(args.is_arg("-no_decos")) {
      rect.origin.y -= 23; //size of APPLE menubar.
    }
  }

  NSWindow* window = 0;
  if(full_screen) {
//#if MAC_OS_X_VERSION_MAX_ALLOWED < 1012
#if MAC_OS_X_VERSION_MAX_ALLOWED <= 1060   //macarts.
    unsigned int mask = NSBorderlessWindowMask;
#else
    unsigned int mask = NSWindowStyleMaskBorderless;
#endif
    window = [[FSWindow alloc] initWithContentRect:rect
                               styleMask:mask
                               backing:NSBackingStoreBuffered
                               defer:NO //we are the owner.
                               screen:screen];
    [window setLevel:NSStatusWindowLevel];
  } else {
//#if MAC_OS_X_VERSION_MAX_ALLOWED < 1012
#if MAC_OS_X_VERSION_MAX_ALLOWED <= 1060   //macarts.
    unsigned int mask = NSTitledWindowMask;
    mask |= NSResizableWindowMask;
    mask |= NSClosableWindowMask;
    mask |= NSMiniaturizableWindowMask;
#else
    unsigned int mask = NSWindowStyleMaskTitled;
    mask |= NSWindowStyleMaskResizable;
    mask |= NSWindowStyleMaskClosable;
    mask |= NSWindowStyleMaskMiniaturizable;
#endif
    if(args.is_arg("-no_decos")) mask = 0;
    window = [[NSWindow alloc] initWithContentRect:rect
                               styleMask:mask
                               backing:NSBackingStoreBuffered
                               defer:NO //we are the owner.
                               screen:screen];
    NSString* title = [NSString stringWithUTF8String:a_app_name.c_str()];
    [window setTitle:title];
    [window setShowsResizeIndicator:YES];
    [window setAcceptsMouseMovedEvents:YES];
  }

  GLView* view = [[GLView alloc] initWithFrame:rect];
  [window setContentView:view];
  [view release];

  [window makeKeyAndOrderFront:app];

  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //NSDictionary* environ = [[NSProcessInfo processInfo] environment];
  //BOOL is_sandboxed = (nil != [environ objectForKey:@"APP_SANDBOX_CONTAINER_ID"]);
  bool is_sandboxed = inlib::is_env("APP_SANDBOX_CONTAINER_ID");

  // Get the .app directory :
  NSString* ns_bundle_dir = [[NSBundle mainBundle] bundlePath];
  std::string bundle_dir = [ns_bundle_dir UTF8String];
  std::string res_dir = bundle_dir+"/Contents/Resources";

  // Get the tmp directory :
  NSString* ns_tmp_dir = NSTemporaryDirectory();
  std::string tmp_dir = [ns_tmp_dir UTF8String];
  inlib::strip(tmp_dir,inlib::trailing,'/');

  // Get the Documents directory :
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
  NSString* ns_doc_dir = [paths objectAtIndex:0];

  std::string doc_dir = [ns_doc_dir UTF8String];
  inlib::strip(doc_dir,inlib::trailing,'/');
  if(!is_sandboxed) doc_dir += inlib::sep()+a_app_name;
  std::string out_dir = doc_dir;

  app_Cocoa::main<APP_MAIN> _main(nsout,doc_dir,res_dir,out_dir,tmp_dir,view,verbose);
  _main.set_argcv(args);
  if(args.is_arg(inlib::s_arg_black())) _main.m_params.m_scene_screen_color = inlib::colorf_black();

  [view set_main:&_main];
  rect = [window frame];
  rect = [window contentRectForFrameRect:rect]; //window content true size.
  [view drawRect:rect];

  //////////////////////////////////////////////////////////////////
  //// app as a scene graph server or client : /////////////////////
  //////////////////////////////////////////////////////////////////
  inlib::sg::view_sg_serv* _view_sg_serv = inlib::sg::cast_view_sg_serv(_main);
  if(_view_sg_serv)
    _view_sg_serv->set_params(0,sg_serv_connect_func,sg_serv_disconnect_func,sg_serv_finalize_func,
			      (void*)window,0);

  inlib::sg::view_sg_client* _view_sg_client = inlib::sg::cast_view_sg_client(_main);
  if(_view_sg_client && _view_sg_client->walls()._walls().empty()) _view_sg_client = 0;

  //////////////////////////////////////////////////////////////////
  /// insh default scripts : ///////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  _main.source_dot_insh();
  _main.exec_startup_insh();
  /*_main.exec_insh_startup();*/

  //////////////////////////////////////////////////////////////////
  /// document file : //////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
 {std::string DOCUMENT;
  args.files_at_end(); //take care of the upper -land.
  if(!args.file(DOCUMENT)) args.find("-document",DOCUMENT);
  if(verbose) {
    NSLog(@"exlib_main : document is %s.",DOCUMENT.c_str());
  }
  //Xcode-4 : app is spawned with args : -NSDocumentRevisionsDebugMode YES
  if(DOCUMENT.size()&&(DOCUMENT!="YES")) {
    _main.create_gui();
    bool done;
    _main.opener().open(DOCUMENT,inlib::file::s_format_guessed(),inlib::args(),done);
  }}

  //////////////////////////////////////////////////////////////////
  /// terminal : ///////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  std::ostream& _term_out = nsout;
#include "../term.icc"  // have to delete _term_timer. Done below.

  //////////////////////////////////////////////////////////////////
  /// steering : ///////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////

  win_delegate* _win_delegate = [[win_delegate alloc] init:&_main sg_serv:_view_sg_serv?&_view_sg_serv->sg_serv():0];
  [window setDelegate:_win_delegate];

  if(_view_sg_client)
    _view_sg_client->set_params(sg_client_start_func<APP_MAIN>,sg_client_stop_func<APP_MAIN>,
				(void*)_win_delegate,(void*)&_main);

  app_delegate* app_del = [[app_delegate alloc] init:&_main];
  [app setDelegate:app_del];

  [app finishLaunching];

  //NSLog(@"debug : enter main loop...");

  while(!_main.to_exit()) {
    bool blocking = true;
    if(_main.num_cbks()) {
      _main.do_works();
      blocking = false; //for animations.
    }
    if(_term_timer && _term_timer->active()) {
      _term_timer->check_time_out();
      blocking = false;
    }
    [_win_delegate get_nsevent:app blocking:blocking];
  }

  delete _term_timer;

  if(_view_sg_serv) _view_sg_serv->set_params(0,0,0,0,0,0);
  if(_view_sg_client) _view_sg_client->set_params(0,0,0,0); //for main and view_sg_client dstors.

  [[NSNotificationCenter defaultCenter] removeObserver:_win_delegate];

  [main_pool release];

#ifdef INLIB_MEM
  }
  #ifndef INLIB_MEM_ATEXIT
  inlib::mem::balance(nsout);
  #endif
  NSLog(@"%s_Cocoa : exit(mem) ...",a_app_name.c_str());
#else
  if(verbose) NSLog(@"%s_Cocoa : exit ...",a_app_name.c_str());
#endif

  return EXIT_SUCCESS;
}

#ifdef USE_NSAPP_RUN
#undef USE_NSAPP_RUN
#endif

// skip because of app_main_t.
//exlib_build_use skip

