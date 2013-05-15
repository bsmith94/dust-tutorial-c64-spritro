;============================================================
; color cycle over text using the sprite pointer of the 
; ship to get the next color 
;============================================================
 
color_cycle ldx #$00 		; init counter for column
 			
color_init  lda sprite_ship_current_frame  ; load ship sprite pointer value...
										   ; ...which is always between $00-$0f

		    cmp #$0f 		; when its #$0f we skip addition of 1 
		    beq color_inc   
			adc #$01   		; otherwise we add 1 eliminating the possibility...
							; ... to get the color black.

color_inc 	sta $d828,x      ; increase colors line 1
            sta $d878,x      ; increate colors line 2
            sbc #$01 		 ; substract 1 from color value in accumulator

			cmp #$00 		 ; if color value becomes 0 (black)...
			beq color_exit	 ; ...then skip this frame 

            inx    			 ; increase column-position counter 
            cpx #$28         ; finished when all 40 cols of a line are processed
            bne color_inc    ; if not finished write new color into register
color_exit  rts 			 ; return
