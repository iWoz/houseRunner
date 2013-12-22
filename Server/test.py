a = { 'b':1, 'a':2 }
print len(a), a

b = 1
b += 1
print b

c = {'d':1}

a['c'] = c
c['c'] = 'c'
print a

# del a['c']
ccc = a.pop('c', None)
print a, c, ccc

for v in a:
	print v

import random

print random.randint(2,100)