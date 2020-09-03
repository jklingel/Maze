         *= $1000

         ; Fill the screen with a random
         ; maze based on slash and
         ; backslash PETSCII codes. At
         ; the end wait for key pressed,
         ; then do it again.

         ; (c) Jan Klingel 2020
         ; based on BASIC code seen from
         ; David the 8-bit Guy.

slash    = $6e
backslash = $6d


         jsr init_random
main
         jsr $e544  ; clear screen
         jsr print_maze
         jsr getkey
         jmp main
;---------------------------------------
print_maze
         .block
         sec
         ldy #25    ; amount of rows

loop_y
         ldx #40    ; amount of columns
loop_x
         lda $d41b  ; get random nr
         sbc 127    ; mid val bw 0-255
         bmi bs
         lda #slash
         jmp print
bs
         lda #backslash
print
         ; The chrout kernal function
         ; expects PETSCII not screen
         ; codes!
         jsr $ffd2  ; chrout
         dex
         bne loop_x
         dey
         bne loop_y
         rts
         .bend
;---------------------------------------
getkey
         ; Return from sub as soon
         ; as any key is pressed.

         jsr $ffe4 ; getin
         beq getkey
         lda #0
         sta $c6   ; clear keyb buffer
         rts
;---------------------------------------
init_random
         ; Prepare SID voice 3.
         ; Get random nr from 0-255 by
         ; loading accu with $d41b.
         ; Load maximum freq ff
         ; into voice 3 lb $d40e
         ; into voice 3 hb $d40f
         ; noice waveform, gate bit off
         ; into voice 3 control register
         ; Call init_random only once!

         lda #$ff
         sta $d40e
         sta $d40f
         lda #$80
         sta $d412
         rts
         .end

