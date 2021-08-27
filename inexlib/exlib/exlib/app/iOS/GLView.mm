// Copyright (C) 2010, Guy Barrand. All rights reserved.
// See the file exlib.license for terms.

// this file needs the cpp macros :
// - EXLIB_APP : for exa #define EXLIB_APP ioda
// It needs also to have included before it a :
//    #include "../<app>/main"

#include "main.hm"

#include <inlib/sg/view_sg_client>
#include <inlib/sg/view_sg_serv>

//#define TRY_NSFILE_HANDLE
//#define TRY_WORK

@interface app_delegate : NSObject<UIApplicationDelegate> {
  GLView* m_view;
  NSLog_streambuf* m_buf;
  std::ostream* m_out;
  app_iOS::main* m_main;
  inlib::sg::view_sg_client* m_view_sg_client;
  inlib::sg::view_sg_serv* m_view_sg_serv;
#ifdef TRY_NSFILE_HANDLE
  NSFileHandle* m_sg_serv_file_handle;
#else
  NSTimer* m_sg_serv_timer;
#endif
}
- (id)init:(GLView*)a_view;
- (void)dealloc;
- (void)applicationWillTerminate:(UIApplication*)a_sender;
- (BOOL)application:(UIApplication*)a_app didFinishLaunchingWithOptions:(NSDictionary*)a_opts;
- (void)applicationDidEnterBackground:(UIApplication*)a_sender;
- (void)applicationWillEnterForeground:(UIApplication*)a_sender;
- (void)applicationDidReceiveMemoryWarning:(UIApplication*)a_sender;
- (BOOL)application:(UIApplication*)a_app openURL:(NSURL*)a_url sourceApplication:(NSString*)a_from annotation:(id)a_annotation;
- (GLView*)get_view;
- (app_iOS::main*)get_main;
- (inlib::sg::view_sg_client*)get_view_sg_client;
- (inlib::sg::view_sg_serv*)get_view_sg_serv;
#ifdef TRY_NSFILE_HANDLE
- (void)set_sg_serv_file_handle:(NSFileHandle*)a_sg_serv_file_handle;
- (NSFileHandle*)get_sg_serv_file_handle;
- (NSFileHandle*)add_fh:(int)a_id selector:(SEL)a_selector;
- (void)remove_fh:(NSFileHandle*)a_fh;
- (void)sg_serv_fh_callback:(NSNotification*)a_not;
#else
- (void)start_sg_serv_timer;
- (void)stop_sg_serv_timer;
#endif
@end

#include <inlib/sg/view_sg_serv>
#ifdef TRY_NSFILE_HANDLE
#ifdef TRY_WORK
class sg_serv_connect_work : public inlib::sg::bcbk {
  typedef inlib::sg::bcbk parent;
public:
  virtual inlib::sg::return_action action() {
    NSFileHandle* fh = [m_app_delegate get_sg_serv_file_handle];
    if(fh) {
      NSLog(@"sg_serv_connect_work::action : WARNING : sg_serv_file_handle not null !");
    } else {
      inlib::sg::view_sg_serv* _view_sg_serv = [m_app_delegate get_view_sg_serv];
      if(_view_sg_serv) {
        if(!_view_sg_serv->is_connected()) {
          NSLog(@"sg_serv_connect_work::action : WARNING : _view_sg_serv not connected !");
        } else {
          NSLog(@"debug : sg_serv_connect_work::action : add_fh");
          [m_app_delegate set_sg_serv_file_handle:
            [m_app_delegate add_fh:_view_sg_serv->socket() selector:@selector(sg_serv_fh_callback:)]];
        }
      }
    }
    return inlib::sg::return_none;
  }
  virtual parent* copy() const {return new sg_serv_connect_work(*this);}
public:
  sg_serv_connect_work(app_delegate* a_app_delegate)
  :parent()
  ,m_app_delegate(a_app_delegate)
  {
    m_single_shoot = true;
  }
  virtual ~sg_serv_connect_work(){}
public:
  sg_serv_connect_work(const sg_serv_connect_work& a_from)
  :parent(a_from)
  ,m_app_delegate(a_from.m_app_delegate)
  {}
  sg_serv_connect_work& operator=(const sg_serv_connect_work& a_from){
    parent::operator=(a_from);
    m_app_delegate = a_from.m_app_delegate;
    return *this;
  }
protected:
  app_delegate* m_app_delegate;
};
inline void sg_serv_initialize_func(void* a_app_delegate,void*){
  NSLog(@"debug : sg_serv_initialize_func.");
  app_delegate* _app_delegate = (app_delegate*)a_app_delegate;
  [[_app_delegate get_view] start_timer];
}
inline void sg_serv_connect_func(inlib::net::sg_serv_args& a_args){
  NSLog(@"debug : sg_serv_connect_func : add work.");
  app_delegate* _app_delegate = (app_delegate*)a_args.m_data_1;
  app_iOS::main* _main = [_app_delegate get_main];
  _main->add_work(new sg_serv_connect_work(_app_delegate));
  //[[_app_delegate get_view] start_timer];
}
#else //TRY_WORK
inline void sg_serv_connect_func(inlib::net::sg_serv_args& a_args){
  NSLog(@"debug : sg_serv_connect_func.");
  app_delegate* _app_delegate = (app_delegate*)a_args.m_data_1;
  NSFileHandle* fh = [_app_delegate get_sg_serv_file_handle];
  if(fh) {
    NSLog(@"sg_serv_connect_func : WARNING : sg_serv_file_handle not null !");
  } else {
    inlib::sg::view_sg_serv* _view_sg_serv = [_app_delegate get_view_sg_serv];
    if(_view_sg_serv) {
      if(!_view_sg_serv->is_connected()) {
        NSLog(@"sg_serv_connect_func : WARNING : _view_sg_serv not connected !");
      } else {
        NSLog(@"debug : sg_serv_connect_func. add_fh");
        [_app_delegate set_sg_serv_file_handle:[_app_delegate add_fh:_view_sg_serv->socket() selector:@selector(sg_serv_fh_callback:)]];
      }
    }
  }
}
#endif //TRY_WORK
inline void sg_serv_disconnect_func(inlib::net::sg_serv_args& a_args){
  NSLog(@"debug : sg_serv_disconnect_func.");
  app_delegate* _app_delegate = (app_delegate*)a_args.m_data_1;
  NSFileHandle* fh = [_app_delegate get_sg_serv_file_handle];
  if(!fh) {
    NSLog(@"sg_serv_disconnect_func : WARNING : sg_serv_file_handle is null !");
  } else {
    [_app_delegate remove_fh:fh];
    [_app_delegate set_sg_serv_file_handle:0];
  }
}
#else
inline void sg_serv_initialize_func(void* a_app_delegate,void*){
  //NSLog(@"debug : sg_serv_initialize_func.");
  app_delegate* _app_delegate = (app_delegate*)a_app_delegate;
  [_app_delegate start_sg_serv_timer];
}
inline void sg_serv_finalize_func(void* a_app_delegate,void*){
  //NSLog(@"debug : sg_serv_finalize_func.");
  app_delegate* _app_delegate = (app_delegate*)a_app_delegate;
  [_app_delegate stop_sg_serv_timer];
}
#endif

@implementation app_delegate
- (id)init:(GLView*)a_view {
  if(self = [super init]) {
    //NSLog(@"debug : app_delegate::init : 0017");

    m_view = a_view;
    m_buf = new NSLog_streambuf();
    m_out = new std::ostream(m_buf);

    // Get the .app directory :
    NSString* bundle_dir = [[NSBundle mainBundle] bundlePath];
    std::string sbundle_dir = [bundle_dir UTF8String];
    std::string res_dir = sbundle_dir;

    // Get the tmp directory :
    NSString* tmp_dir = NSTemporaryDirectory();
    std::string stmp_dir = [tmp_dir UTF8String];
    inlib::strip(stmp_dir,inlib::trailing,'/');

    // Get the Documents directory :
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);

    NSString* ndoc_dir = [paths objectAtIndex:0];
    std::string doc_dir = [ndoc_dir UTF8String];
    inlib::strip(doc_dir,inlib::trailing,'/');

    std::string out_dir = doc_dir;

    bool verbose = false;
    //verbose = true;

    m_main = new app_iOS::main(*m_out,doc_dir,res_dir,out_dir,stmp_dir,verbose);

    m_main->set_GLView(a_view);

    m_view_sg_client = inlib::sg::cast_view_sg_client(*m_main);
    //if(!m_view_sg_client) {
    //  NSLog(@"app_delegate : APP_USE_WALL but main not a inlib::sg::view_sg_client.");
    //}

    m_view_sg_serv = inlib::sg::cast_view_sg_serv(*m_main);
#ifdef TRY_NSFILE_HANDLE
    m_sg_serv_file_handle = 0;
    if(m_view_sg_serv) {
      //NSLog(@"debug : app_delegate::init : 1000");
      m_view_sg_serv->set_params(0,sg_serv_connect_func,sg_serv_disconnect_func,0,self,0);
    }
#else
    if(m_view_sg_serv) m_view_sg_serv->set_params(sg_serv_initialize_func,0,0,sg_serv_finalize_func,self,0);
    m_sg_serv_timer = 0;
#endif

    m_main->source_dot_insh();
    m_main->exec_startup_insh();
    /*m_main->exec_insh_startup();*/

    //NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //[center addObserver:self selector:@selector(mem_pb:)
    //               name:UIApplicationDidReceiveMemoryWarningNotification
    //               object:self];
  }
  return self;
}
- (void)dealloc {
#ifdef TRY_NSFILE_HANDLE
  if(m_sg_serv_file_handle) {
    [self remove_fh:m_sg_serv_file_handle];
    m_sg_serv_file_handle = 0;
  }
#endif
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  m_main->set_GLView(0);
  delete m_main;
  delete m_out;
  delete m_buf;

  [super dealloc];
}
- (GLView*)get_view {return m_view;}
- (app_iOS::main*)get_main {return m_main;}
- (inlib::sg::view_sg_client*)get_view_sg_client {return m_view_sg_client;}
- (inlib::sg::view_sg_serv*)get_view_sg_serv {return m_view_sg_serv;}
- (void)applicationDidEnterBackground:(UIApplication*)a_sender {
  //NSLog(@"debug : delegate applicationDidEnterBackground : 004 : ********");
  (void)a_sender;
}
- (void)applicationWillEnterForeground:(UIApplication*)a_sender {
  //NSLog(@"debug : delegate applicationWillEnterForeground !!!!!!!!");
  (void)a_sender;
}
- (void)applicationWillResignActive:(UIApplication*)a_sender {
  //NSLog(@"debug : delegate applicationWillResignActive : 001 : !!!!!!!!");
  if(m_view_sg_client) m_view_sg_client->disconnect_from_sg_serv();
  [m_view set_disable_GL:true];
  (void)a_sender;
}
- (void)applicationDidBecomeActive:(UIApplication*)a_sender {
  //NSLog(@"debug : delegate applicationDidBecomeActive : 004 : !!!!!!!!");
  [m_view set_disable_GL:false];
  //in case an openURL is done (then whilst being in background).
  m_main->win_render();
  (void)a_sender;
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication*)a_sender {
  //NSLog(@"debug : delegate : applicationDidReceiveMemoryWarning");
  m_main->set_memory_warning(true);
  //[[ImageCache sharedImageCache] removeAllImagesInMemory];
  (void)a_sender;
}

//- (void)mem_pb:(id)a_sender{
//  NSLog(@"debug : delegate : mem_pb");
//  m_main->set_memory_warning(true);
//}


- (void)applicationWillTerminate:(UIApplication*)a_sender {
  //NOTE :
  // with iOS 3.2 : when hiting the home button we passed here.
  // with iOS 4.0 : by default hiting the home button passes
  //                the process in "background" and we do not
  //                pass here anymore. Even if stopping the
  //                process from the app-drawer. To stop
  //                when passing in backgroup, and the pass here,
  //                you have to set UIApplicationExitsOnSuspend
  //                to </true>in the Info.plist.
  //NSLog(@"debug : delegate applicationWillTerminate : 0004 : =========");

  if(m_view_sg_serv) m_view_sg_serv->set_params(0,0,0,0,0,0);
  if(m_view_sg_client) m_view_sg_client->set_params(0,0,0,0);

  [m_view set_disable_GL:true];
  delete m_main;m_main = 0;
  delete m_out;m_out = 0;
  delete m_buf;m_buf = 0;
  (void)a_sender;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000 //__IPHONE_OS_VERSION_6_0
- (BOOL)application:(UIApplication*)a_app didFinishLaunchingWithOptions:(NSDictionary*)a_opts {return YES;}
#else
- (NSUInteger)application:(UIApplication*)a_app supportedInterfaceOrientationsForWindow:(UIWindow*)a_window {return UIInterfaceOrientationMaskAll;}
- (BOOL)application:(UIApplication*)a_app didFinishLaunchingWithOptions:(NSDictionary*)a_opts {
  UIWindow* window = [[UIApplication sharedApplication] keyWindow];
  [window setRootViewController:[m_view get_view_controller_delegate]];
  return YES;
}
#endif

- (BOOL)application:(UIApplication*)a_app openURL:(NSURL*)a_url sourceApplication:(NSString*)a_from annotation:(id)a_annotation {
  //NSLog(@"debug : openURL ++006++++");
  if(!m_main) return NO;
  if([a_url isFileURL]) {
    //std::string document = [[a_url path] UTF8String]; //to be tried.

    NSString* nss = [a_url absoluteString];
    //NSLog(@"debug : openURL : file URL NSString \"%@\"",nss);
    //NSLog(@"debug : openURL : file URL UTF8String \"%s\"",[nss UTF8String]);
    std::string document = [nss UTF8String];
    if(document.substr(0,16)=="file://localhost") {
      document = document.substr(16,document.size()-16); //keep a /
    }
    if(document.substr(0,7)=="file://") { //if opened from Mail.
      document = document.substr(7,document.size()-7); //keep a /
    }
    if(document.empty()) return NO;

    //NSLog(@"debug : openURL : 001 : document \"%s\"",document.c_str());

    if(!inlib::file::exists(document)) {
      NSLog(@"debug : openURL : inlib::file::exists(document) failed for \"%s\"",document.c_str());
      // From GoodReader, a file with white spaces in name is "Open in"
      // with spaces replaced with "%20". Check for that :
      inlib::replace(document,"%20"," ");
      if(!inlib::file::exists(document)) {
        NSLog(@"debug : openURL : inlib::file::exists(document) (2) failed for \"%s\"",document.c_str());
        return NO;
      }
    }

    //create_gui() needed if called at startup through didFinishLaunching
    m_main->create_gui();
    //Huum, the below push_home() seems to induce a crash if agora spawned from Mail doing "Open with..."
    //m_main->push_home(); //Why we had that here ?

    //m_main->clear_scene();
    bool done;
    bool status = m_main->opener().open(document,inlib::file::s_format_guessed(),inlib::args(),done);
    if(!status) {
       NSLog(@"debug : openURL : main.opener().open(document) failed for \"%s\"",document.c_str());
       return NO;
    }
    if(!done) {
      NSLog(@"debug : openURL : main.opener().open(document) not done for \"%s\"",document.c_str());
      return NO;
    }
    //NSLog(@"debug : openURL : open() looks ok.");
    //no need to do win_render since we are probably in background.
    return YES;
  } else { //custom URL.
    return NO;
  }
  (void)a_app;
  (void)a_from;
  (void)a_annotation;
}

#ifdef TRY_NSFILE_HANDLE
- (void)set_sg_serv_file_handle:(NSFileHandle*)a_sg_serv_file_handle {m_sg_serv_file_handle = a_sg_serv_file_handle;}
- (NSFileHandle*)get_sg_serv_file_handle {return m_sg_serv_file_handle;}
- (NSFileHandle*)add_fh:(int)a_id selector:(SEL)a_selector {
  NSLog(@"debug : add_fh : socket %d",a_id);
  NSFileHandle* fh = [[NSFileHandle alloc] initWithFileDescriptor:a_id];
  [fh waitForDataInBackgroundAndNotify];
  [[NSNotificationCenter defaultCenter] addObserver:self
     selector:a_selector name:NSFileHandleDataAvailableNotification object:fh];
  return fh;
}
- (void)remove_fh:(NSFileHandle*)a_fh {
  NSLog(@"debug : remove_fh.");
  [[NSNotificationCenter defaultCenter]
    removeObserver:self name:NSFileHandleDataAvailableNotification object:a_fh];
}
- (void)sg_serv_fh_callback:(NSNotification*)a_not {
  NSLog(@"debug : sg_serv_fh_callback.");
  NSFileHandle* fh = (NSFileHandle*)[a_not object];
  if(!fh) return;

  if(m_view_sg_serv) {
    NSLog(@"debug : sg_serv_fh_callback : 001");
    if(!m_view_sg_serv->treat_event(exlib::decompress_buffer)) {
      NSLog(@"view_controller_delegate::sg_serv_fh_callback : view_sg_serv::treat_event() failed.");
      m_main->map_warn("view_sg_serv : treat_event() failed.");
      m_main->win_render();
    }
  }

  [fh waitForDataInBackgroundAndNotify];
}
#else
- (void)start_sg_serv_timer{
  if(m_sg_serv_timer) return; //done.
  //NSLog(@"debug : start_sg_serv_timer : 0007.");
  double seconds = 1./10.;
  m_sg_serv_timer =
    [NSTimer scheduledTimerWithTimeInterval:seconds
				     target:self
				   selector:@selector(sg_serv_timer_proc:)
				   userInfo:nil repeats:TRUE];
}
- (void)stop_sg_serv_timer{
  if(!m_sg_serv_timer) return; //done.
  //NSLog(@"debug : stop_sg_serv_timer.");
  [m_sg_serv_timer invalidate];
  m_sg_serv_timer = 0;
}
- (void)sg_serv_timer_proc:(id)a_sender{
  //static unsigned int s_sg_serv_timer_count = 0;
  //NSLog(@"debug : sg_serv_timer_proc %d",s_sg_serv_timer_count);s_sg_serv_timer_count++;

  if(m_view_sg_serv && m_view_sg_serv->is_connected()) {
    bool have_input;
    if(!m_view_sg_serv->is_there_input(have_input)) {
      //NSLog(@"inlib::sg_client::poll : is_there_input failed.");
    }
    if(have_input) {
      if(!m_view_sg_serv->treat_event(exlib::decompress_buffer)) {
        m_main->map_warn("view_sg_serv : treat_event() failed.");
        //_main->win_render();
        //[self window_render];
      }
    }
  }

  (void)a_sender;
}
#endif

@end

@implementation GLView

// You must implement this method
+ (Class)layerClass {
  return [CAEAGLLayer class];
}

// NOTE from Apple :
// The EAGL view is stored in the nib file.
// When it's unarchived it's sent -initWithCoder:

- (id)initWithCoder:(NSCoder*)a_coder {
  if ((self = [super initWithCoder:a_coder])) {
  //NSLog(@"debug : GLView::initWithCode : 004");

    // We want all the screen :
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    CAEAGLLayer* eaglLayer = (CAEAGLLayer*)self.layer;

    eaglLayer.opaque = TRUE;
    eaglLayer.drawableProperties =
      [NSDictionary dictionaryWithObjectsAndKeys:
       [NSNumber numberWithBool:FALSE],
       kEAGLDrawablePropertyRetainedBacking,
       kEAGLColorFormatRGBA8,
       kEAGLDrawablePropertyColorFormat,
       nil];

    m_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    if (!m_context || ![EAGLContext setCurrentContext:m_context]) {
      [self release];
      return nil;
    }

    // Create default framebuffer object.
    // The backing will be allocated for the
    // current layer in -resizeFromLayer
    glGenFramebuffersOES(1,&m_frame_buffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES,m_frame_buffer);

    glGenRenderbuffersOES(1,&m_color_buffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES,m_color_buffer);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES,
                                 GL_COLOR_ATTACHMENT0_OES,
                                 GL_RENDERBUFFER_OES,
                                 m_color_buffer);

    glGenRenderbuffersOES(1,&m_depth_buffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES,m_depth_buffer);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES,
                                 GL_DEPTH_ATTACHMENT_OES,
                                 GL_RENDERBUFFER_OES,
                                 m_depth_buffer);

    // Antialiasing :
#ifdef EXLIB_IOS_ANTIALIASING
    glGenFramebuffersOES(1,&m_aa_frame_buffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES,m_aa_frame_buffer);

    glGenRenderbuffersOES(1,&m_aa_color_buffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES,m_aa_color_buffer);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES,
                                 GL_COLOR_ATTACHMENT0_OES,
                                 GL_RENDERBUFFER_OES,
                                 m_aa_color_buffer);

    glGenRenderbuffersOES(1,&m_aa_depth_buffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES,m_aa_depth_buffer);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES,
                                 GL_DEPTH_ATTACHMENT_OES,
                                 GL_RENDERBUFFER_OES,
                                 m_aa_depth_buffer);
#endif

    m_view_controller_delegate = [[view_controller_delegate alloc] init];
    m_view_controller_delegate.view = self;

    m_app_delegate = [[app_delegate alloc] init:self]; //it creates app_iOS::main.
    [[UIApplication sharedApplication] setDelegate:m_app_delegate];

    app_iOS::main* _main = [m_app_delegate get_main];
    inlib::sg::gui_viewer* _gui_viewer = inlib::sg::cast_gui_viewer(*_main);
    [m_view_controller_delegate set_gui_viewer:_gui_viewer];

    //m_draw_count = 0;
    m_disable_GL = false;

    m_timer = 0;

   {//begin gesture declarations :
/*
    UITapGestureRecognizer* tap_gesture =
     [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(single_tap_gesture:)];
    tap_gesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap_gesture];

    UITapGestureRecognizer* double_tap_gesture =
     [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(double_tap_gesture:)];
    double_tap_gesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:double_tap_gesture];
    [tap_gesture requireGestureRecognizerToFail:double_tap_gesture];
    [tap_gesture release];
    [double_tap_gesture release];

   {UIPanGestureRecognizer* pan_gesture = [[UIPanGestureRecognizer alloc]
        initWithTarget:self action:@selector(pan_gesture:)];
    [self addGestureRecognizer:pan_gesture];
    [pan_gesture release];}

*/
   {UIPinchGestureRecognizer* pinch_gesture =
     [[UIPinchGestureRecognizer alloc]
        initWithTarget:self action:@selector(pinch_gesture:)];
    [self addGestureRecognizer:pinch_gesture];
    [pinch_gesture release];}

/*
   {UIPanGestureRecognizer* pan_gesture_2 = [[UIPanGestureRecognizer alloc]
        initWithTarget:self action:@selector(pan_gesture_2:)];
    [pan_gesture_2 setMinimumNumberOfTouches:2];
    //[pan_gesture_2 requireGestureRecognizerToFail:pinch_gesture];
    [self addGestureRecognizer:pan_gesture_2];
    [pan_gesture_2 release];}
*/

/*
   {UIRotationGestureRecognizer* rotation_gesture =
      [[UIRotationGestureRecognizer alloc]
        initWithTarget:self action:@selector(rotation_gesture:)];
    //[rotation_gesture requireGestureRecognizerToFail:pinch_gesture];
    [self addGestureRecognizer:rotation_gesture];
    [rotation_gesture release];}

    UISwipeGestureRecognizer* swipe_gesture = [[UISwipeGestureRecognizer alloc]
        initWithTarget:self action:@selector(swipe_gesture:)];
    //UISwipeGestureRecognizerDirectionRight //default
    //UISwipeGestureRecognizerDirectionLeft
    //UISwipeGestureRecognizerDirectionUp
    //UISwipeGestureRecognizerDirectionDown
    [swipe_gesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [swipe_gesture setNumberOfTouchesRequired:1]; //default is 1.
    [self addGestureRecognizer:swipe_gesture];
    [pan_gesture requireGestureRecognizerToFail:swipe_gesture];
    [swipe_gesture release];

    UILongPressGestureRecognizer* long_press_gesture =
      [[UILongPressGestureRecognizer alloc]
          initWithTarget:self action:@selector(long_press_gesture:)];
    [long_press_gesture setMinimumPressDuration:2]; //1 sec = default.
    [long_press_gesture setNumberOfTouchesRequired:1]; //default is 1.
    [self addGestureRecognizer:long_press_gesture];
    [long_press_gesture release];
*/
    } //end gestures.

  }

  return self;
}

- (void)dealloc {

  [self stop_timer];

  if(m_frame_buffer) {
    glDeleteFramebuffersOES(1,&m_frame_buffer);
    m_frame_buffer = 0;
  }

  if(m_color_buffer) {
    glDeleteRenderbuffersOES(1,&m_color_buffer);
    m_color_buffer = 0;
  }

  if(m_depth_buffer) {
    glDeleteRenderbuffersOES(1,&m_depth_buffer);
    m_depth_buffer = 0;
  }

#ifdef EXLIB_IOS_ANTIALIASING
  if(m_aa_frame_buffer) {
    glDeleteFramebuffersOES(1,&m_aa_frame_buffer);
    m_aa_frame_buffer = 0;
  }

  if(m_aa_color_buffer) {
    glDeleteRenderbuffersOES(1,&m_aa_color_buffer);
    m_aa_color_buffer = 0;
  }

  if(m_aa_depth_buffer) {
    glDeleteRenderbuffersOES(1,&m_aa_depth_buffer);
    m_aa_depth_buffer = 0;
  }
#endif

  if([EAGLContext currentContext] == m_context) [EAGLContext setCurrentContext:nil];

  [m_context release];
  m_context = nil;

  [m_view_controller_delegate release];
  m_view_controller_delegate = 0;

  [super dealloc];
}

- (view_controller_delegate*)get_view_controller_delegate {return m_view_controller_delegate;}

- (void)start_timer{
#ifdef USE_DISPLAY_LINK
  if(m_timer) return; //done.
  //NSLog(@"debug : start_timer (USE_DISPLAY_LINK) : 0001.");
  m_timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(timer_proc:)];
  [m_timer setFrameInterval:1];
  [m_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
#else
  if(m_timer) return; //done
  //NSLog(@"debug : start_timer : 0001.");
  double seconds = 1./60.; // 0.016666
  m_timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timer_proc:) userInfo:nil repeats:TRUE];
#endif
}

- (void)stop_timer{
  if(!m_timer) return; //done.
  [m_timer invalidate];
  m_timer = 0;
}

- (void)timer_proc:(id)a_sender{
  //static unsigned int s_timer_count = 0;
  //NSLog(@"debug : timer_proc %d",s_timer_count);s_timer_count++;

  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;

  _main->do_works();
  //_main->move_timer().check_time_out();
  bool timer_stop = true;
  if(_main->num_cbks() /*||_main->move_timer().active()*/ ) timer_stop = false;

 {inlib::sg::view_sg_client* _view_sg_client = [m_app_delegate get_view_sg_client];
  if(_view_sg_client && _view_sg_client->is_connected()) {
    //the below handles inlib::wall::protocol::disconnect()
    if(!_view_sg_client->sg_client().poll()) {}
    if(!_view_sg_client->is_connected()) {
      //NSLog(@"debug : disconnected");
      //we have received a inlib::wall::protocol::disconnect()
      _main->map_warn("disconnected");
      //_main->win_render();
      [self window_render];
    } else {
      timer_stop = false;
    }
  }}

  if(timer_stop) [self stop_timer];
  (void)a_sender;
}

- (void)set_disable_GL:(bool)a_value {
  m_disable_GL = a_value;
}

- (void)layoutSubviews {
  //NSLog(@"debug : layoutSubviews");
  if(m_disable_GL) return;

  // Allocate color buffer backing based on the current layer size
  glBindRenderbufferOES(GL_RENDERBUFFER_OES,m_color_buffer);
  [m_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];

  GLint ww;
  GLint wh;
  glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES,GL_RENDERBUFFER_WIDTH_OES,&ww);
  glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES,GL_RENDERBUFFER_HEIGHT_OES,&wh);

  glBindRenderbufferOES(GL_RENDERBUFFER_OES,m_depth_buffer);
  glRenderbufferStorageOES(GL_RENDERBUFFER_OES,
                           GL_DEPTH_COMPONENT16_OES,
                           ww,wh);

#ifdef EXLIB_IOS_ANTIALIASING
  glBindRenderbufferOES(GL_RENDERBUFFER_OES,m_aa_color_buffer);
  glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER_OES,2,GL_RGB5_A1_OES,ww,wh);

  glBindRenderbufferOES(GL_RENDERBUFFER_OES,m_aa_depth_buffer);
  glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER_OES,2,GL_DEPTH_COMPONENT16_OES,ww,wh);
#endif

  if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES)!=GL_FRAMEBUFFER_COMPLETE_OES) {
    NSLog(@"GLView::layoutSubviews : failed to make complete framebuffer object %x",
          glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
    return;
  }

  app_iOS::main* _main = [m_app_delegate get_main];
  if(_main) _main->set_size(ww,wh);

  [self window_render];
}

- (void)window_render {
  //NSLog(@"debug : render : draw_count %u %d",m_draw_count,m_disable_GL);
  //m_draw_count++;
  if(m_disable_GL) return;

  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;

  [EAGLContext setCurrentContext:m_context];

#ifdef EXLIB_IOS_ANTIALIASING
  glBindFramebufferOES(GL_FRAMEBUFFER_OES,m_aa_frame_buffer);
  bool old_produce_out_jpeg = _main->produce_out_jpeg();
  _main->set_produce_out_jpeg(false);
  bool old_produce_out_png = _main->produce_out_png();
  _main->set_produce_out_png(false);
#else
  glBindFramebufferOES(GL_FRAMEBUFFER_OES,m_frame_buffer);
#endif

  _main->render();

#ifdef EXLIB_IOS_ANTIALIASING
 {GLenum attachments[] = {GL_DEPTH_ATTACHMENT_OES};
  glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE,1,attachments);}
  glBindFramebufferOES(GL_READ_FRAMEBUFFER_APPLE,m_aa_frame_buffer);
  glBindFramebufferOES(GL_DRAW_FRAMEBUFFER_APPLE,m_frame_buffer);
  glResolveMultisampleFramebufferAPPLE();
#endif

  glBindRenderbufferOES(GL_RENDERBUFFER_OES,m_color_buffer);

#ifdef EXLIB_IOS_ANTIALIASING
  if(old_produce_out_jpeg||old_produce_out_png) {
    glBindFramebufferOES(GL_READ_FRAMEBUFFER_APPLE,m_color_buffer);
    _main->set_produce_out_jpeg(old_produce_out_jpeg);
    _main->set_produce_out_png(old_produce_out_png);
    _main->after_render();
  }
#endif

  [m_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)touchesBegan:(NSSet*)a_touches withEvent:(UIEvent*)a_event {
  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;
  UITouch* touch = [[a_touches allObjects] objectAtIndex:0];
  CGPoint p = [touch locationInView:touch.view];
  //CGPoint previousLocation = [touch previousLocationInView:touch.view];
  // p = (0,0) = top left of window.
  //NSLog(@"debug : touchesBegan %d : %g %g",[a_touches count],p.x,p.y);
  unsigned int wh = _main->height();
  if(_main->touch_down(p.x,wh-p.y)) [self window_render];
  _main->do_works(); //for arm cbks.
  (void)a_event;
}

- (void)touchesMoved:(NSSet*)a_touches withEvent:(UIEvent*)a_event {
  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;
  UITouch* touch = [[a_touches allObjects] objectAtIndex:0];
  CGPoint p = [touch locationInView:touch.view];
  //NSLog(@"debug : touchesMoved %d : %g %g",[a_touches count],p.x,p.y);
  if(_main->touch_move(p.x,_main->height()-p.y)) [self window_render];
  _main->do_works(); //treat single shoot cbks.
  (void)a_event;
}

- (void)touchesEnded:(NSSet*)a_touches withEvent:(UIEvent*)a_event {
  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;
  UITouch* touch = [[a_touches allObjects] objectAtIndex:0];
  CGPoint p = [touch locationInView:touch.view];
  // p = (0,0) = top left of window.
  //NSLog(@"debug : touchesEnded %d : %g %g",[a_touches count],p.x,p.y);
  _main->add_work_check_arm_buttons();
  unsigned int wh = _main->height();
  if(_main->touch_up(p.x,wh-p.y)) [self window_render];
  inlib::sg::view_sg_client* _view_sg_client = [m_app_delegate get_view_sg_client];
  bool dc_connected = false;
  if(_view_sg_client) dc_connected = _view_sg_client->is_connected();
  _main->do_works(); //treat single shoot cbks.
  if(_main->num_cbks()) { //see if not single shoot cbks remain.
    [self start_timer];
  }
  if(_view_sg_client && !dc_connected && _view_sg_client->is_connected()) {
    [self start_timer];
  }
  //if(_main->to_exit()) {
    // how to exit properly ?
    //::exit(0); //this produce a Segmentation fault.
  //}
  (void)a_event;
}

- (void)pinch_gesture:(UIGestureRecognizer*)a_sender {
  CGFloat scale = [(UIPinchGestureRecognizer*)a_sender scale];
  if(scale<=0) return;
  //NSLog(@"debug : GLView::pinch_gesture : %g",scale);

  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;

  if(_main->ui_visible()      ||
     _main->camenu_visible()  ||
     _main->sliders_visible() ||
     _main->popup_visible()
  ){
    _main->add_work_check_arm_buttons();
    _main->do_works(); //treat single shoot cbks.
    return;
  }

  inlib::sg::base_camera* camera = _main->scene_camera();
  if(!camera) return;

  //float cooking = 1.0f;
  //scale *= cooking;

  if(inlib::sg::ortho* oc = inlib::safe_cast<inlib::sg::base_camera,inlib::sg::ortho>(*camera)) {

    if (a_sender.state == UIGestureRecognizerStateBegan) {
      m_pinch_began = oc->height.value(); //save starting height.
    } else if (a_sender.state == UIGestureRecognizerStateFailed) {
      oc->height.value(m_pinch_began);
    } else if( (a_sender.state == UIGestureRecognizerStateChanged) ||
               (a_sender.state == UIGestureRecognizerStateEnded)   ){
      oc->height.value(m_pinch_began*(1.0f/scale));
      [self window_render];
    }

  } else if(inlib::safe_cast<inlib::sg::base_camera,inlib::sg::perspective>(*camera)) {

    if (a_sender.state == UIGestureRecognizerStateBegan) {

      _main->start_gesture(0,0);

    } else if (a_sender.state == UIGestureRecognizerStateFailed) {

      _main->reset_camera_with_saved();
      [self window_render];

    } else if( (a_sender.state == UIGestureRecognizerStateChanged) ||
               (a_sender.state == UIGestureRecognizerStateEnded)   ){

      unsigned int saved_xcursor,saved_ycursor;
      inlib::sg::base_camera* saved_camera =
        _main->saved_cursor_and_camera(saved_xcursor,saved_ycursor);

      if(camera && saved_camera) {
        float dx = camera->dx.value();
        dx *= 15; //ok with povama.
        float trans = dx*(scale-1);

        camera->position.value(saved_camera->position.value());
        camera->translate_along_dir(trans);

        [self window_render];
      }
    }

  }
}

/*

- (void)rotation_gesture:(UIRotationGestureRecognizer*)a_sender {
  CGFloat gangle = [a_sender rotation]; //radians
  // gangle > 0 clockwise.
  //NSLog(@"debug : GLView::rotation_gesture %g",gangle);

  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;

  if(_main->ui_or_camenu_visible()) {
    _main->add_work_check_arm_buttons();
    _main->do_works(); //treat single shoot cbks.
    return;
  }

  inlib::sg::base_camera* camera = _main->scene_camera();
  if(!camera) return;

  if (a_sender.state == UIGestureRecognizerStateBegan) {

    _main->start_gesture(0,0);

  } else if (a_sender.state == UIGestureRecognizerStateFailed) {

    _main->reset_camera_with_saved();
    [self window_render];

  } else if( (a_sender.state == UIGestureRecognizerStateChanged) ||
             (a_sender.state == UIGestureRecognizerStateEnded)   ){

    unsigned int saved_xcursor,saved_ycursor;
    inlib::sg::base_camera* saved_camera =
      _main->saved_cursor_and_camera(saved_xcursor,saved_ycursor);

    camera->orientation.value(saved_camera->orientation.value());
    camera->rotate_around_direction(-gangle);

    [self window_render];
  }
}

- (void)single_tap_gesture:(UIGestureRecognizer*)a_sender {
  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;
  CGPoint p = [a_sender locationInView:self];
  // p = (0,0) = top left of window.
  //NSLog(@"debug : GLView::single_tap_gesture %g %g",p.x,p.y);
}

- (void)double_tap_gesture:(UIGestureRecognizer*)a_sender {
  //NSLog(@"debug : GLView::double_tap_gesture");
  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;
  _main->toggle_param_viewing();
  //[self window_render];
}

- (void)pan_gesture:(UIPanGestureRecognizer*)a_sender {
  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;
  CGPoint trans = [a_sender translationInView:self];
  // trans.x goes left to right.
  // trans.y goes top to down.
  //NSLog(@"debug : GLView::pan_gesture %g %g",trans.x,trans.y);
}

- (void)pan_gesture_2:(UIPanGestureRecognizer*)a_sender {
  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;
  CGPoint trans = [a_sender translationInView:self];
  // trans.x goes left to right.
  // trans.y goes top to down.
  //NSLog(@"debug : GLView::pan_gesture %g %g",trans.x,trans.y);
}

- (void)swipe_gesture:(UISwipeGestureRecognizer*)a_sender {
  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;
  //NSLog(@"debug : GLView::swipe_gesture : dir %d",[a_sender direction]);
  if (a_sender.state == UIGestureRecognizerStateBegan) {
  } else if (a_sender.state == UIGestureRecognizerStateFailed) {
  } else if( (a_sender.state == UIGestureRecognizerStateChanged) ||
             (a_sender.state == UIGestureRecognizerStateEnded)   ){
  }
}

- (void)long_press_gesture:(UILongPressGestureRecognizer*)a_sender {
  app_iOS::main* _main = [m_app_delegate get_main];
  if(!_main) return;
  //NSLog(@"debug : GLView::long_press_gesture");
  if (a_sender.state == UIGestureRecognizerStateBegan) {
  } else if (a_sender.state == UIGestureRecognizerStateFailed) {
  } else if( (a_sender.state == UIGestureRecognizerStateChanged) ||
             (a_sender.state == UIGestureRecognizerStateEnded)   ){
  }
}
*/

// skip because of EXLIB_APP
//exlib_build_use skip

//exlib_build_use inlib expat
//exlib_build_use exlib png jpeg zlib inlib_glutess freetype
//exlib_build_use GL

@end

