section .data
    welcome_msg db 'Welcome to the Number Guessing Game!', 0xA, 0
    welcome_len equ $ - welcome_msg

    input_msg db 'Enter your guess (0-100): ', 0
    input_len equ $ - input_msg

    too_high_msg db 'Too High!', 0xA, 0
    too_high_len equ $ - too_high_msg

    too_low_msg db 'Too Low!', 0xA, 0
    too_low_len equ $ - too_low_msg

    invalid_msg db 'Invalid input. Only numbers 0–100 allowed.', 0xA, 0
    invalid_len equ $ - invalid_msg

    correct_msg db 'Correct! You guessed it!', 0xA, 0
    correct_len equ $ - correct_msg

    play_again_msg db 'Play again? (Y/N): ', 0
    play_again_len equ $ - play_again_msg

    bye_msg db 'Thanks for playing!', 0xA, 0
    bye_len equ $ - bye_msg

section .bss
    user_input resb 10
    random_number resd 1
    user_guess resd 1
    play_again_input resb 5

section .text
    global _start

_start:
main_game_loop:
    ; show welcome
    mov eax, 4
    mov ebx, 1
    mov ecx, welcome_msg
    mov edx, welcome_len
    int 0x80

    ; generate random number
    call generate_random

game_loop:
    ; prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, input_msg
    mov edx, input_len
    int 0x80

    ; read input
    mov eax, 3
    mov ebx, 0
    mov ecx, user_input
    mov edx, 10
    int 0x80

    ; parse integer
    call string_to_int_strict
    cmp edx, 0
    je invalid

    mov [user_guess], eax

    ; check range
    cmp eax, 0
    jl invalid
    cmp eax, 100
    jg invalid

    ; compare
    mov ebx, [random_number]
    cmp eax, ebx
    je correct
    jl too_low

too_high:
    mov eax, 4
    mov ebx, 1
    mov ecx, too_high_msg
    mov edx, too_high_len
    int 0x80
    jmp game_loop

too_low:
    mov eax, 4
    mov ebx, 1
    mov ecx, too_low_msg
    mov edx, too_low_len
    int 0x80
    jmp game_loop

invalid:
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_msg
    mov edx, invalid_len
    int 0x80
    jmp game_loop

correct:
    mov eax, 4
    mov ebx, 1
    mov ecx, correct_msg
    mov edx, correct_len
    int 0x80

ask_play_again:
    mov eax, 4
    mov ebx, 1
    mov ecx, play_again_msg
    mov edx, play_again_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, play_again_input
    mov edx, 5
    int 0x80

    movzx eax, byte [play_again_input]
    cmp eax, 'Y'
    je main_game_loop
    cmp eax, 'y'
    je main_game_loop
    cmp eax, 'N'
    je exit_game
    cmp eax, 'n'
    je exit_game
    jmp ask_play_again

exit_game:
    mov eax, 4
    mov ebx, 1
    mov ecx, bye_msg
    mov edx, bye_len
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

; -------- Helpers --------

; Generate random 0–100
generate_random:
    mov eax, 13      ; sys_time
    xor ebx, ebx
    int 0x80
    mov edx, 0
    mov ecx, 101
    div ecx          ; edx = remainder 0–100
    mov [random_number], edx
    ret

; String to int, strict (no '-' or '+')
; eax = result, edx=1 if ok, 0 if invalid
string_to_int_strict:
    mov esi, user_input
    mov eax, 0
    mov edx, 0
.next:
    mov bl, [esi]
    cmp bl, 0xA
    je .done
    cmp bl, 0
    je .done
    cmp bl, '-'
    je .bad
    cmp bl, '+'
    je .bad
    cmp bl, '0'
    jb .bad
    cmp bl, '9'
    ja .bad
    imul eax, eax, 10
    sub bl, '0'
    movzx ecx, bl
    add eax, ecx
    mov edx, 1
    inc esi
    jmp .next
.done:
    ret
.bad:
    xor edx, edx
    ret
