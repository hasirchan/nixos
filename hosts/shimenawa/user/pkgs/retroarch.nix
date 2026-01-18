{ ... }:
{
  programs.retroarch = {
    enable = true;
    cores = {
      mesen.enable = true;
      mesen-s.enable = true;
      mgba.enable = true;
    };
    settings = {
      input_player1_a = "l";
      input_player1_b = "j";
      input_player1_x = "semicolon";
      input_player1_y = "k";
      input_player1_start = "enter";
      input_player1_select = "rshift";
      input_player1_l = "q";
      input_player1_r = "e";
      input_player1_left = "a";
      input_player1_right = "d";
      input_player1_up = "w";
      input_player1_down = "s";
      input_toggle_fast_forward = "space";
      input_hold_fast_forward = "tab";
      input_toggle_slowmotion = "alt";
      input_hold_slowmotion = "ctrl";
      input_frame_advance = "+";
      video_driver = "sdl";
      pause_nonactive = "true";
      pause_on_disconnect = "true";
    };
  };
}
