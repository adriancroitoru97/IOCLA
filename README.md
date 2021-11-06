# IOCLA - Tema 1 - Sistemul lui Biju

A Linux file system simulation. Simple operations (touch, mkdir,
rm, rmdir, tree, mv etc.) applied to files and directories.

## Implementation

The project is based on two linked lists structures - Dir and File. The root
of the file system is a directory called "home", which is initialized at the
beginning of the program. The program takes inputs from stdin and breaks them
into 2 substrings - the operation and the file(s)/directory(ies) name(s) on
which the operation is applied. Then, the operation's according function is
called. The program is stopped by calling the "stop" command.

## Functions

Almost all the functions in the program are based on linked list operations.
For instance, the touch, mkdir, rm, rmdir functions use the same algorithms
used for adding/removing an element of a linked list.

### sentence_breaker
Splits a string "word1 word2 word3 ... wordN" into two substrings - "word1" and
"word2 word3 ... wordN". It is useful as all the operations in the program have
only 1 or 2 parameters - the operation and a file/directory. The exception is
the operation mv, which has 3 parameters. In that case, the same algorithm is
used to break the "word2 word3" string.

### check_existance_(file/dir)
Checks if a file/dir with a specific name exists. If true, the function
returns 1 and a pointer parameter to that file/dir.
Otherwise, it returns 0 and the pointer is set to NULL.

### pwd
Goes through the list backwards and creates a string - "d4/d3/d2/d1/home/".
It reverses this string to the final path - "/home/d1/d2/d3/d4".

### tree and stop
These functions uses the same principle - recursively seek each directory
and the files it contains.

### mv
Checks if "oldname" belongs to a file or a directory. It changes its name
to "newname" and append it at the end of the list of files/directories. It uses
linked list operations to break and remake the links between nodes after
the moving of the element.

## Memory management

The memory used for strings and structures is dynamically allocated and freed
at the end of the program (when the "stop" function is called).

## License
[Adrian-Valeriu Croitoru](https://github.com/adriancroitoru97/)