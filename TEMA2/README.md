# IOCLA - Tema 2 - Memoria lui Biju

4 independent functions implemented in Assembly Language.


## Functions

### Reversed One Time Pad

Iterate every char of the plaintext string and use the formula:
```
ciphertext[i] = plain[i] ^ key[len - i - 1]
```
to build the ciphertext string.

### Ages

Loops the array of dates and for each one:

First find the difference between the current year and the current person's
year.\
If it is less or equal to 0, the person has an invalid age (in this case the
value written in the ages array will be 0).\
Otherwise, it compares the current month and day with the person's in order to
discover if the person celebrated it's birthday this year and the age
is updated accordingly.

For each person, when the algorithm is done and the age is set,
it is added in the all_ages array.

### Columnar Transposition Cipher

A virtual columnar transposition matrix is cloned by using pointers.

The formula used for generating the new ciphered string:
```
ciphertext[k++] = haystack[j * len_cheie + key[i]]
```
i -> [0, ceil(len_haystack / len_cheie)) \
j -> [0, len_cheie) \
k -> [0, len_haystack)

So, in order to simulate the operations on a matrix, there are two loops
for i and j. At every step, it is verified that the char to be added in the
ciphered text exists, as the columnar transposition matrix can contain more
elements than the initial string.

### Cache Load Simulation

The address tag and offset are obtained using shifts on bits.

The tags array is looped to find out if the searched element exists in cache
or it has to be brought there.

If it exists, the 'cache_hit' label is called and the element is simply put
in the 'reg' variable using the formula:
```
*reg = cache[to_replace * CACHE_LINE_SIZE + address_offset]
```

If the element doesn't exist, the 'cache_miss' label is called.\
Using shifts, the first element on the new line in cache is calculated.\
A loop is used to update every element of the new line, using 0-7 offsets.\
When the whole line in the cache matrix is updated, the queried element is put
in 'reg' using the above formula.\
After everything is done, the tags array is also updated with the new tag
at index 'to_replace'.


## License
[Adrian-Valeriu Croitoru](https://github.com/adriancroitoru97/)
