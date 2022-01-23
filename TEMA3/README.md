# IOCLA - Tema 3 - Infernul lui Biju

4 mandatory and 4 optional tasks implemented in Assembly language. Worked with
stack, functions, **CPUID** command, **SIMD** architecture, **Intel** and
**AT&T** syntaxes, on 32 and 64-bit.


## Tasks

### Task 1 - Sortarea albumelor
As the given array contains exactly all numbers from 1 to n (the array's length),
there is a [1..n] loop. Each number is searched in the array. When the root is
found, it is pushed on the stack. Then, when another node is found, the previous
node is popped from the stack and its `next` field is set to the current node.
Finally, the previous node and the newly found one are pushed on the stack.
This process continues for every node. At the end of the program, the stack is
freed and the last element on stack - the first added - is popped in `EAX` register.


### Task 2 - Cosmarul lui Turing
All `MOV` operations are converted to `PUSH/POP`.\
The **CMMMC** function consists in repeatedly increasing both numbers with
themselves until they become equal.\
The **par** function is implemented using stack. When a `(` character is found,
it is pushed on the stack. On the other hand, a `)` character will generate
a `pop` operation. The stack should always be empty at the end of the program
and there shouldn't be more `POP` then `PUSH` operations.


### Task 3 - Sortare de cuvinte
The **sort** function simply consists in pushing the parameters on the stack,
calling the `qsort` function and the stack restoration.\
**get_words** function uses `strtok` to break a string into words and place
them in an array of strings.
The **compare_func** uses `strlen` and `strcmp` to compare two given strings
by length and, in case of equality, lexicographically.


### Task 4 - Conturi Bancare
This task implies **mutual recursion**. The general order of the recursion is
`EXPRESSION - TERM - FACTOR - EXPRESSION`. At the lowest level, the `FACTOR`
function converts a string to a integer and calls the `EXPRESSION` function in
case of a `(` character. `TERM` and `FACTOR` functions use loops to find
all `+, -, *, /` operations and calculate them. The recursion is naturally ended
when `)` or `\0` character are found. The main idea of the implementation is that
a big expression is broken in small pieces - an `EXPRESSION` is composed of
`TERMS`, which are composed of several `FACTORS`.


### BONUS - Assembly 64bit
The parameters of the function are transmitted by specific
registers - `RDI, RSI, RDX, RCX and R8`. Even though the architecture is on 64bits,
the concrete solution is almost the same with a 32bit one. Only the addresses of the
variables are on 8 bytes, but the integers are still on 4. The 2 arrays are
traversed at the same time, until one of them is over. The other one is after
added at the end of the newly created array.


### BONUS - AT&T Syntax
The two arrays are traversed and added to the `v` array. Then the `positions.h`
positions are scaled to the dimension of the current array and the value for
each position is substracted from the `v` array previously initialized. 


### BONUS - Intructiuni speciale - CPUID
In case of each function, `PUSHA` and `POPA` operations are done because the `CPUID`
command changes the values of the registers, which would generate
a `Segmentation fault`. First step is to initialize the `EAX` register with the
characteristic value of the information we want to obtain. Shifts and `TEST`
operations are done to obtain the concrete data, which will be stored in specific
registers for each call.


### BONUS - Instructiuni vectoriale - SSE, AVX
The task was finished using `AVX2` instructions. As these instructions can only
handle 256 bits at one time, there is a loop iterating from 8 to 8 elements.\
Firstly, 8 `s` values are pushed on the stack and this array is moved in the `ymm0`
register using `vmovdqu` command. This register will be used for doing
the `s * A` operation. This operation and `B .* C` are simply done with `vpmulld`
command - which also works with packed integer values. `vmovups` command is used
to handle memory transfers between `YMM` special registers and heap.


## License
[Adrian-Valeriu Croitoru](https://github.com/adriancroitoru97)