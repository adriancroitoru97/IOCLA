#include "positions.h"
/*
 * Don't forget to include "positions.h"
 */

.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the values provided in positions.S, as described
 * in the task
 */

add_vect:
	pushl 	%ebp
	movl	%esp, %ebp

	/* eax - v1 ; ebx - v2 ; ecx - n ; edx - v */
	movl	8(%ebp), %eax
	movl	12(%ebp), %ebx
	movl	16(%ebp), %ecx
	movl	20(%ebp), %edx

	/* v[] = v1[] + v2[] */
	loop_arrays:
		cmpl 	$0, %ecx
		jl 		done_loop_arrays

		xorl 	%edx, %edx
		addl 	(%eax,%ecx, 4), %edx
		addl 	(%ebx,%ecx, 4), %edx

		movl	20(%ebp), %eax
		movl 	%edx, (%eax, %ecx, 4)
		movl	8(%ebp), %eax

		subl 	$1, %ecx
		jmp 	loop_arrays
	done_loop_arrays:

	/* v[] = v[] - positions */
	movl	16(%ebp), %eax
	movl 	$FIRST_POSITION, %ebx
	mull	%ebx
	movl 	$10, %ebx
	divl	%ebx 					/* now eax contains the scaled position */
	movl 	$FIRST_VALUE, %ebx 		/* ebx contains the value */

	movl	20(%ebp), %edx			/* the v array */
	subl	%ebx, (%edx, %eax, 4)


	movl	16(%ebp), %eax
	movl 	$SECOND_POSITION, %ebx
	mull	%ebx
	movl 	$10, %ebx
	divl	%ebx 					/* now eax contains the scaled position */
	movl 	$SECOND_VALUE, %ebx 	/* ebx contains the value */

	movl	20(%ebp), %edx			/* the v array */
	subl	%ebx, (%edx, %eax, 4)


	movl	16(%ebp), %eax
	movl 	$THIRD_POSITION, %ebx
	mull	%ebx
	movl 	$10, %ebx
	divl	%ebx 					/* now eax contains the scaled position */
	movl 	$THIRD_VALUE, %ebx 		/* ebx contains the value */

	movl	20(%ebp), %edx			/* the v array */
	subl	%ebx, (%edx, %eax, 4)

	leave
	ret
