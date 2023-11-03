section .data
    output_string db "Hello, World!",0
    buffer_size equ 64

section .bss
    buffer resb buffer_size
    reversed_buffer resb buffer_size
    uppercase_buffer resb buffer_size

section .text
    global main
    extern printf, pthread_create, pthread_join, pthread_exit
    global _start

main:
    ; Copy the output string to the buffer
    mov rdi, buffer
    mov rsi, output_string
    call copy_string

    ; Print the original string
    mov rdi, buffer
    call print_string

    ; Reverse the string
    mov rdi, buffer
    mov rsi, reversed_buffer
    call reverse_string

    ; Print the reversed string
    mov rdi, reversed_buffer
    call print_string

    ; Convert the string to uppercase
    mov rdi, buffer
    mov rsi, uppercase_buffer
    call to_uppercase

    ; Print the uppercase string
    mov rdi, uppercase_buffer
    call print_string

    ; Create two threads to work on the data
    mov rdi, 1
    mov rsi, buffer
    call create_thread

    mov rdi, 2
    mov rsi, reversed_buffer
    call create_thread

    ; Wait for the threads to finish
    call wait_threads

    ; Exit the program
    call exit_program


reverse_string:
    ; Reverse a null-terminated string from rdi to rsi
    xor rcx, rcx
    xor rdx, rdx
    .loop_reverse:
    mov al, [rdi + rcx]
    mov [rsi + rdx], al
    inc rcx
    dec rdx
    cmp byte [rdi + rcx], 0
    jnz .loop_reverse
    ret

to_uppercase:
    ; Convert a null-terminated string to uppercase in-place
    xor rcx, rcx
    .loop_uppercase:
    mov al, [rdi + rcx]
    cmp al, 97  ; Check if lowercase 'a'
    jl .not_lowercase
    cmp al, 122 ; Check if lowercase 'z'
    jg .not_lowercase
    sub al, 32  ; Convert to uppercase
    .not_lowercase:
    mov [rdi + rcx], al
    inc rcx
    cmp byte [rdi + rcx], 0
    jnz .loop_uppercase
    ret


_start:
    call main
    call exit_program
