section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	enter 	0, 0
	pusha

	mov 	eax, 0	
	cpuid
	mov 	eax, [ebp + 8]
	mov 	[eax], ebx
	mov 	[eax + 4], edx
	mov 	[eax + 8], ecx

	popa
	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise
features:
	enter 	0, 0
	pusha
	
	; initialize vmx, rdrand, avx with 0
	mov 	eax, [ebp + 8]
	mov 	[eax], dword 0
	mov 	eax, [ebp + 12]
	mov 	[eax], dword 0
	mov 	eax, [ebp + 16]
	mov 	[eax], dword 0

	vmx_test:
		mov 	eax, 1	
		cpuid

		; the 5th bit of ecx register represents the vmx feature
		shr 	ecx, 5
		test 	ecx, 1
		jz 		rdrand_test

		; vmx = 1
		mov 	eax, [ebp + 8]
		mov 	[eax], dword 1	

	rdrand_test:
		mov 	eax, 1	
		cpuid

		; the 30th bit of ecx register represents the rdrand feature
		shr 	ecx, 30
		test 	ecx, 1
		jz 		avx_test

		; rdrand = 1
		mov 	eax, [ebp + 12]
		mov 	[eax], dword 1

	avx_test:
		mov 	eax, 1	
		cpuid

		; the 28th bit of ecx register represents the avx feature
		shr 	ecx, 28
		test 	ecx, 1
		jz 		done_features

		; avx = 1
		mov 	eax, [ebp + 16]
		mov 	[eax], dword 1

	done_features:
	popa
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0
	pusha

	line_size:
		; 80000006h	- extended L2 cache features
		mov 	eax, 80000006h		
		cpuid

		; bits 07-00 for line_size
		and		ecx, 0xff		
		mov 	eax, [ebp + 8]
		mov 	[eax], ecx

	total_cache_size:
		; 80000006h	- extended L2 cache features
		mov 	eax, 80000006h		
		cpuid

		; bits 31-16 for cache_size
		shr 	ecx, 16
		and 	ecx, 0xffff
		mov 	eax, [ebp + 12]
		mov 	[eax], ecx

	popa
	leave
	ret
