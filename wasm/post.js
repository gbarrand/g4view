Module.app_initialize   = Module.cwrap('app_initialize' ,'number',['string','number', 'number']);
Module.app_win_render   = Module.cwrap('app_win_render' ,'void',['void']);
Module.app_after_render = Module.cwrap('app_after_render' ,'void',['void']);
Module.app_set_size     = Module.cwrap('app_set_size'   ,'void',['number','number']);
Module.app_do_works     = Module.cwrap('app_do_works'   ,'number',['void']);
Module.app_button_down  = Module.cwrap('app_button_down','void',['number','number','number']);
Module.app_button_up    = Module.cwrap('app_button_up'  ,'void',['number','number','number']);
Module.app_button_move  = Module.cwrap('app_button_move','void',['number','number','number']);

Module.app_upload_file       = Module.cwrap('app_upload_file','void',['string','number','number','number']);
Module.app_open_doc_file     = Module.cwrap('app_open_doc_file','void',['string','string']);
Module.app_upload_buffer     = Module.cwrap('app_upload_buffer','void',['number','number','string']);
Module.app_get_file_size     = Module.cwrap('app_get_file_size','number',['string']);
Module.app_get_file          = Module.cwrap('app_get_file','number',['string']);
Module.app_source_insh       = Module.cwrap('app_source_insh','void',['string']);
Module.app_upload_rgbas      = Module.cwrap('app_upload_rgbas','void',['number','number']);
Module.app_delete_buffer     = Module.cwrap('app_delete_buffer','void',['number']);

Module.app_map_warn          = Module.cwrap('app_map_warn','void',['string','number']);
Module.app_pop_list          = Module.cwrap('app_pop_list','void',['void']);

Module.app_doc_files_to_ui   = Module.cwrap('app_doc_files_to_ui','void',['void']);

Module.app_enable_terminal  = Module.cwrap('app_enable_terminal','void',['void']);
Module.app_disable_terminal = Module.cwrap('app_disable_terminal','void',['void']);
Module.app_tab              = Module.cwrap('app_tab','number',['string','number']);
Module.app_tab_completion   = Module.cwrap('app_tab_completion','string',['void']);
