{ inputs, ... }:
{
  den.aspects.mango = {
    nixos = { ... }: {
      imports = [ inputs.mango.nixosModules.mango ];
      programs.mango.enable = true;
    };
    homeManager = { pkgs, ... }: {
      imports = [ inputs.mango.hmModules.mango ];
      wayland.windowManager.mango = {
        enable = true;
        systemd.enable = true;

        settings = {
          # Window effects — disabled
          blur = 0;
          blur_layer = 0;
          shadows = 0;
          layer_shadows = 0;
          shadow_only_floating = 1;

          # Border
          border_radius = 6;
          no_radius_when_single = 0;
          focused_opacity = 1.0;
          unfocused_opacity = 1.0;
          borderpx = 4;
          no_border_when_single = 0;
          bordercolor = "0x444444ff";
          focuscolor = "0xc9b890ff";
          rootcolor = "0x201b14ff";
          maximizescreencolor = "0x89aa61ff";
          urgentcolor = "0xad401fff";
          scratchpadcolor = "0x516c93ff";
          globalcolor = "0xb153a7ff";
          overlaycolor = "0x14a57cff";

          # Animations
          animations = 1;
          layer_animations = 1;
          animation_type_open = "slide";
          animation_type_close = "slide";
          animation_fade_in = 1;
          animation_fade_out = 1;
          tag_animation_direction = 1;
          zoom_initial_ratio = 0.4;
          zoom_end_ratio = 0.8;
          fadein_begin_opacity = 0.5;
          fadeout_begin_opacity = 0.8;
          animation_duration_move = 500;
          animation_duration_open = 400;
          animation_duration_tag = 350;
          animation_duration_close = 800;
          animation_duration_focus = 0;
          animation_curve_open = "0.46,1.0,0.29,1";
          animation_curve_move = "0.46,1.0,0.29,1";
          animation_curve_tag = "0.46,1.0,0.29,1";
          animation_curve_close = "0.08,0.92,0,1";
          animation_curve_focus = "0.46,1.0,0.29,1";
          animation_curve_opafadeout = "0.5,0.5,0.5,0.5";
          animation_curve_opafadein = "0.46,1.0,0.29,1";

          # Gaps
          gappih = 20;
          gappiv = 10;
          gappoh = 10;
          gappov = 10;
          smartgaps = 0;

          # Scratchpad
          scratchpad_width_ratio = 0.8;
          scratchpad_height_ratio = 0.9;

          # Layout
          default_mfact = 0.55;
          default_nmaster = 1;
          new_is_master = 1;
          scroller_structs = 20;
          scroller_default_proportion = 0.8;
          scroller_focus_center = 0;
          scroller_prefer_center = 0;
          edge_scroller_pointer_focus = 1;
          scroller_default_proportion_single = 1.0;
          scroller_proportion_preset = "0.5,0.8,1.0";

          # Overview
          hotarea_size = 10;
          enable_hotarea = 1;
          ov_tab_mode = 0;
          overviewgappi = 5;
          overviewgappo = 30;

          # Misc
          axis_bind_apply_timeout = 100;
          focus_on_activate = 1;
          sloppyfocus = 1;
          warpcursor = 1;
          focus_cross_monitor = 0;
          focus_cross_tag = 0;
          enable_floating_snap = 0;
          snap_distance = 30;
          drag_tile_to_tile = 1;

          # Keyboard
          repeat_rate = 25;
          repeat_delay = 600;
          numlockon = 0;
          xkb_rules_layout = "us,gr";

          # Trackpad
          tap_to_click = 1;
          tap_and_drag = 1;
          drag_lock = 1;
          trackpad_natural_scrolling = 0;
          disable_while_typing = 1;
          left_handed = 0;
          middle_button_emulation = 0;
          swipe_min_threshold = 1;

          # Mouse
          mouse_natural_scrolling = 1;
          cursor_size = 24;
          cursor_theme = "Adwaita";

          # Tag rules
          tagrule = [
            "id:1,layout_name:tile"
            "id:2,layout_name:tile"
            "id:3,layout_name:tile"
            "id:4,layout_name:tile"
            "id:5,layout_name:tile"
            "id:6,layout_name:tile"
            "id:7,layout_name:tile"
            "id:8,layout_name:tile"
            "id:9,layout_name:tile"
          ];

          # Layer rules
          layerrule = [
            "animation_type_open:zoom,layer_name:rofi"
            "animation_type_close:zoom,layer_name:rofi"
          ];

          # Keybinds
          bind = [
            "super+shift,q,reload_config"
            "super,space,spawn,fuzzel -I"
            "super,Return,spawn,kitty"
            "super+ctrl,q,quit"
            "super,c,killclient,"
            "super,Tab,focusstack,next"
            "super,Left,focusdir,left"
            "super,Right,focusdir,right"
            "super,Up,focusdir,up"
            "super,Down,focusdir,down"
            "super,h,focusdir,left"
            "super,l,focusdir,right"
            "super,k,focusdir,up"
            "super,j,focusdir,down"
            "super+shift,Up,exchange_client,up"
            "super+shift,Down,exchange_client,down"
            "super+shift,Left,exchange_client,left"
            "super+shift,Right,exchange_client,right"
            "super+shift,h,focusdir,left"
            "super+shift,l,focusdir,right"
            "super+shift,k,focusdir,up"
            "super+shift,j,focusdir,down"
            "super,g,toggleglobal,"
            "super+shift,Tab,toggleoverview,"
            "super,backslash,togglefloating,"
            "super,m,togglemaximizescreen,"
            "super,f,togglefullscreen,"
            "super+shift,f,togglefakefullscreen,"
            "super,i,minimized,"
            "super,o,toggleoverlay,"
            "super+shift,I,restore_minimized"
            "super,z,toggle_scratchpad"
            "super,e,set_proportion,1.0"
            "super,x,switch_proportion_preset,"
            "super,n,switch_layout"
            "super+ctrl,Left,viewtoleft,0"
            "super+ctrl,Right,viewtoright,0"
            "super+ctrl+shift,Left,tagtoleft,0"
            "super+ctrl+shift,Right,tagtoright,0"
            "super,1,view,1,0"
            "super,2,view,2,0"
            "super,3,view,3,0"
            "super,4,view,4,0"
            "super,5,view,5,0"
            "super,6,view,6,0"
            "super,7,view,7,0"
            "super,8,view,8,0"
            "super,9,view,9,0"
            "super+alt,1,comboview,1"
            "super+alt,2,comboview,2"
            "super+alt,3,comboview,3"
            "super+alt,4,comboview,4"
            "super+alt,5,comboview,5"
            "super+alt,6,comboview,6"
            "super+alt,7,comboview,7"
            "super+alt,8,comboview,8"
            "super+alt,9,comboview,9"
            "super+shift,1,tag,1,0"
            "super+shift,2,tag,2,0"
            "super+shift,3,tag,3,0"
            "super+shift,4,tag,4,0"
            "super+shift,5,tag,5,0"
            "super+shift,6,tag,6,0"
            "super+shift,7,tag,7,0"
            "super+shift,8,tag,8,0"
            "super+shift,9,tag,9,0"
            "super,backspace,view,-1"
            "super+SHIFT,X,incgaps,1"
            "super+SHIFT,Z,incgaps,-1"
            "super+SHIFT,R,togglegaps"
            "super+alt,Up,movewin,+0,-50"
            "super+alt,Down,movewin,+0,+50"
            "super+alt,Left,movewin,-50,+0"
            "super+alt,Right,movewin,+50,+0"
            "super+alt+shift,Up,resizewin,+0,-50"
            "super+alt+shift,Down,resizewin,+0,+50"
            "super+alt+shift,Left,resizewin,-50,+0"
            "super+alt+shift,Right,resizewin,+50,+0"
            "super,r,setkeymode,resize"
          ];

          mousebind = [
            "SUPER,btn_left,moveresize,curmove"
            "NONE,btn_middle,togglemaximizescreen,0"
            "SUPER,btn_right,moveresize,curresize"
          ];

          keymode = {
            resize = {
              bind = [
                "NONE,Left,resizewin,-10,0"
                "NONE,Right,resizewin,+10,0"
                "NONE,h,resizewin,-10,0"
                "NONE,l,resizewin,+10,0"
                "NONE,Escape,setkeymode,default"
                "NONE,Return,setkeymode,default"
              ];
            };
          };
        };

        # autostart_sh = ''
        # '';
      };
    };
  };
}
