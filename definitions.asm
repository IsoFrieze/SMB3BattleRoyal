; definitions.asm
; all variables

!controller_byetudlr_hold = $F0 ; $F2
!controller_axlr_hold = $F4 ; $F4
!controller_byetudlr_frame = $F8 ; $F6
!controller_axlr_frame = $FC ; $F8

!player_animation_frame = $E0 ; $8D

!winner_of_game = $078C
!number_won_games = $02DA ; $02DA
!number_won_matches = $02DE ; $02DE

!player_status = $1700 ; $1800
!player_y_position_low = $1704 ; $1811
!player_x_position = $1708 ; $1822
!player_y_speed = $170C ; $1833
!player_x_speed = $1710 ; $1844
!player_animation_timer = $1714 ; $1855
!player_direction = $1718 ; $1864
!player_y_speed_subpixel = $171C ; $1873
!player_x_speed_subpixel = $1720 ; $1884
!player_direction_interaction = $1724 ; $1895
!player_kicking_timer = $1728 ; $18B3
!player_squished_timer = $172C ; $18B5
!player_frozen_vertically_timer = $1730 ; $18B7
!player_interaction_disabled = $1734 ; $18B9
!player_sprite_lock = $1738 ; $18CB
!player_death_timer_a = $173C ; $18E7
!player_jumped = $1740 ; $18F6
!player_walking_on_tile = $1744 ; $18F8
!player_invinsible = $1748 ; $190A
!player_below_tile = $174C ; $190F
!player_coin_count = $1750 ; $192E
!player_y_offset = $1754 ; $193F
!player_y_position_high = $1758 ; $1942
!player_death_timer_b = $175C ; $1987
!player_death_timer_b = $1760 ; $1989
!player_walking_fraction_bits = $1764 ; $199C
!player_walking_frame = $1768 ; $199E
!player_size = $176C ; $19AB
!player_ducking = $1770 ; $19AD
!player_changing_size = $1774 ; $19AF
!player_next_size = $1778 ; $19B1
!player_flashing_timer = $177C ; $19B3
!player_pressed_button = $1780 ; $19B5


!player_tiles = $0240