.memorymap
defaultslot 0
slotsize $8000
slot 0 $8000
.endme

.rombankmap
bankstotal 6
banksize $0010
banks 1
banksize $8000
banks 4
banksize $8000
banks 1
.endro

.background "expanded.nes"

.equ    ROTATION_ANGLE              $b0
.equ    NEW_BUTTONS_P1              $f5
.equ    HELD_BUTTONS_P1             $f7
.equ    MASK_BUTTON_RIGHT           $01
.equ    MASK_BUTTON_LEFT            $02
.equ    CURRENT_SEMICIRCLE          $7ff
.equ    SWITCH_TO_CHR_BANK          $8466
.equ    BANK_SWITCHING_ADDRESS      $dfce


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.bank 1 slot 0
.orga $8472
        ; adapt CHR bank switching to GNROM
        .db     $00, $01, $02, $03

.orga $9840
        jsr     reset_semicircle
        nop

.orga $ffd9
reset_semicircle:
        ; replace original instructions
        lda     $00
        sta     $b0

        lda     #0
        sta     CURRENT_SEMICIRCLE
        rts

.orga BANK_SWITCHING_ADDRESS
switch_to_prg_bank_1:
        ldy     #0
        lda     #$10
        sta     .bank1, y
        jmp     SWITCH_TO_CHR_BANK
        rts
.bank1
        .db     $10

.orga $9a66
        jmp     switch_to_prg_bank_1



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.bank 2 slot 0
.orga BANK_SWITCHING_ADDRESS
switch_to_prg_bank_0:
        ldy     #0
        lda     #0
        sta     .bank0, y
        jsr     my_code
        jmp     switch_to_prg_bank_0
.bank0
        .db     $00

my_code:
        jsr     check_for_new_button_presses
        jsr     check_for_held_button_presses
        rts

check_for_new_button_presses:
        lda     NEW_BUTTONS_P1
        and     #(MASK_BUTTON_RIGHT|MASK_BUTTON_LEFT)
        bne     .save_semicircle
        rts
.save_semicircle
        lda     ROTATION_ANGLE
        and     #$80
        sta     CURRENT_SEMICIRCLE
        rts

check_for_held_button_presses:
.check_for_right_press
        lda     HELD_BUTTONS_P1
        and     #MASK_BUTTON_RIGHT
        bne     .have_right_press
        lda     HELD_BUTTONS_P1
        and     #MASK_BUTTON_LEFT
        bne     .have_left_press
        rts
.have_right_press
        lda     CURRENT_SEMICIRCLE
        bne     turn_cw
        jmp     turn_ccw
.have_left_press
        lda     CURRENT_SEMICIRCLE
        bne     turn_ccw
        jmp     turn_cw

turn_cw:
        inc     ROTATION_ANGLE
        inc     ROTATION_ANGLE
        rts

turn_ccw:
        dec     ROTATION_ANGLE
        dec     ROTATION_ANGLE
        rts
