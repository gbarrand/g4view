
var g_term_line = "";
var g_term_history = [];
var g_term_history_pos = 0;
var g_term_pos = 0;

var g_term = null;
var g_Module_app_inited = false;

var g_term_clear_line = "";
var g_term_cols = 180;  //particle_print => 178, pdg => 164. But then the right red border is no more visible.

var g_done_key = false;

const gui_terminal = document.getElementById('gui_terminal');
if(gui_terminal!=null) {
  g_term = new Terminal();
    
//let font_size = g_term.getOption('fontSize')
//let cols = font_size?Math.floor(gui_terminal.clientWidth/font_size):132;
  g_term.resize(g_term_cols,10);

/*    
  let leftPadding = parseInt(getComputedStyle(document.querySelector('.terminal-outer-container')).paddingLeft.split('px')[0], 10);
  let innerWidth = dimension.width - leftPadding;
  let cols = Math.floor(innerWidth / font.charWidth);
  let rows = Math.floor(dimension.height / font.charHeight);
  if (this._xterm) {
    this._xterm.resize(cols, rows);
    this._xterm.element.style.width = innerWidth + 'px';
  }
*/
    
  g_term.open(gui_terminal);
  g_term_clear_line = '\r$ '+Array(g_term.cols-2+1).join(' '); //2=size of prompt.
  g_term.set_cursor = () => {
    let n = g_term_line.length-g_term_pos;
    let _set_cursor = n>=1?Array(n+1).join('\b'):"";
    g_term.write(g_term_clear_line+'\r$ '+g_term_line+_set_cursor);
  }
  g_term.write('$ ');
    
  g_term.onKey(g_term_onKey);

  g_term.onData(g_term_onData);  //to handle paste.
    
  gl_canvas_resize();    
}

function g_term_onKey(a_event) {
  key_code = a_event.key.charCodeAt(0);
  code = a_event.domEvent.code;
  key = a_event.key;
  g_term_do_key(key_code,code,key);
  g_done_key = true;
}

function g_term_do_key(a_key_code,a_code,a_key) {
  //console.log('debug : g_term_do_key : key_code ',a_key_code);
  //console.log('debug : g_term_do_key : code ',a_code);
  //console.log('debug : g_term_do_key : key ',a_key);
  if(g_Module_app_inited==false) {
   Module.app_enable_terminal();
   g_Module_app_inited = true;
  }
  if (a_key_code == 13) {  //carriage return:
    //console.log('exlib::wasm::terminal.js : '+g_term_line);
    g_term.write('\r\n');
    term_exec(g_term_line);	
    g_term_line = ""
    g_term_pos = g_term_line.length;
    g_term.set_cursor();
    g_term_history_pos = 0;
  } else if (a_key_code == 127) { //dom = Backspace. Do not delete the prompt:
    if(g_term_line.length>=1) {
      if(g_term_pos>0) {
        g_term_line =
          g_term_line.substr(0,g_term_pos-1)+g_term_line.substr(g_term_pos,g_term_line.length);
        g_term_pos--;
        g_term.set_cursor();
      }
    }
  } else if(a_code=='ArrowUp') {
    if(g_term_history.length>=1) {
      if(g_term_history_pos==(g_term_history.length-1)) {
        g_term_line = g_term_history[g_term_history_pos];
        g_term_pos = g_term_line.length;
        g_term.write(g_term_clear_line+'\r$ '+g_term_line);
      } else if(g_term_history_pos<g_term_history.length) {
        g_term_line = g_term_history[g_term_history_pos];
        g_term_pos = g_term_line.length;
        g_term.write(g_term_clear_line+'\r$ '+g_term_line);
        g_term_history_pos++;
      }
    }
  } else if(a_code=='ArrowDown') {
    if(g_term_history.length>=1) {
      if(0==g_term_history_pos) {
        g_term_line = g_term_history[g_term_history_pos];
        g_term_pos = g_term_line.length;
        g_term.write(g_term_clear_line+'\r$ '+g_term_line);
      } else if(0<g_term_history_pos) {
        g_term_line = g_term_history[g_term_history_pos];
        g_term_pos = g_term_line.length;
        g_term.write(g_term_clear_line+'\r$ '+g_term_line);
        g_term_history_pos--;
      }
    }
  } else if(a_code=='ArrowRight') {
    if(g_term_pos<g_term_line.length) {
      g_term_pos++;
      g_term.set_cursor();
    }	
  } else if(a_code=='ArrowLeft') {
    if(g_term_pos>0) {
      g_term_pos--;
      g_term.set_cursor();
    }	
  } else if (a_key_code == 9) { //dom = Tab.
    let loc = Module.app_tab(g_term_line,g_term_pos);
    if(loc>=0) {
      if(loc!=g_term_pos) g_term_line = Module.app_tab_completion();  
      g_term_pos = loc;
    }
    g_term.set_cursor();
  } else if (a_key_code == 1) { //dom = KeyA.
    g_term_pos = 0;
    g_term.set_cursor();
  } else if (a_key_code == 5) { //dom = KeyE.
    g_term_pos = g_term_line.length;
    g_term.set_cursor();
  } else if ( (32<=a_key_code) && (a_key_code<=126) ) {
    if(g_term_pos>=g_term_line.length) {
      g_term_line += a_key;
      g_term_pos = g_term_line.length;
      g_term.set_cursor();
    } else {
      g_term_line = g_term_line.substr(0,g_term_pos)+a_key+g_term_line.substr(g_term_pos,g_term_line.length);
      g_term_pos++;
      g_term.set_cursor();
    }	
  }
}

function g_term_onData(a_event) {
  if(g_done_key==true) {
    g_done_key = false;
  } else {
    //console.log('debug : g_term_onData : 000',a_event);
    g_term_line = g_term_line.substr(0,g_term_pos)+a_event+g_term_line.substr(g_term_pos,g_term_line.length);
    g_term_pos += a_event.length;
    g_term.set_cursor();
  }
}

function term_exec(a_line) {
  if((a_line.length>=2)&&(a_line.substr(0,2)=='!!')) {
    if(g_term_history.length>0) {
      let ss = a_line.substr(2,a_line.length);
      term_exec(g_term_history[0]+ss);
    }
  } else if((a_line.length>=1)&&(a_line[0]=='!')) {
    let ss = a_line.substr(1,a_line.length);
    if((ss>=1)&&(ss<=g_term_history.length)) {
      let n = g_term_history.length;
      term_exec(g_term_history[n-(ss-1)-1]);
    } else {
      let lss = ss.length;
      let i = 0;
      let n = g_term_history.length;
      for(i;i<n;i++) {
        let shist = g_term_history[i];
        if(lss<=shist.length) {
          if(ss==shist.substr(0,lss)) {
            term_exec(shist);
          }
        }
      }
    }
  } else {	  
    if(a_line.length>0) g_term_history.unshift(a_line);
    if(a_line=='history') {
      let i = 0;
      let n = g_term_history.length;
      for(i;i<n;i++) {
        g_term.write(' '+(i+1)+' '+g_term_history[n-i-1]+'\n\r');
      }
    } else {
      Module.app_source_insh(a_line);
    }
  }
}

function term_write_c_string(a_s) {
  if(g_term==null) {
    console.log(UTF8ToString(a_s));
  } else {
    g_term.write(UTF8ToString(a_s)+'\r');
  }
}

function term_set_rows(a_rows) {
  if(a_rows<=0) a_rows = 10;
  g_term.resize(g_term.cols,a_rows);
  window_resize();
}

function term_set_cols(a_cols) {
  if(a_cols<=0) a_cols = g_term_cols;
  g_term.resize(a_cols,g_term.rows);
  window_resize();
}
