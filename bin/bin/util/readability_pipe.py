#!/usr/bin/env python
#
# Executes python-readability on current page and opens the summary as new tab.
#
# Depends on the python-readability package, or its fork:
#
#   - https://github.com/buriy/python-readability
#   - https://github.com/bookieio/breadability
#
import os
import sys

tmpfile = os.path.join(
    os.environ.get('XDG_CACHE_HOME',
                   os.path.expanduser('~/.cache')),
    'util/readability.html')

if not os.path.exists(os.path.dirname(tmpfile)):
    os.makedirs(os.path.dirname(tmpfile))

# with open(sys.argv[1], 'r') as input_f:
# with open(sys.stdin, 'r') as input_f:
data = sys.stdin.read()

try:
    from breadability.readable import Article as reader
    doc = reader(data)
    content = doc.readable
except ImportError:
    from readability import Document
    doc = Document(data)
    content = doc.summary().replace('<html>', '<html><head><title>%s</title></head>' % doc.title())
print('<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />')
print(content)


# with codecs.open(tmpfile, 'w', 'utf-8') as target:
#     target.write('<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />')
#     target.write(content)

# with open(os.environ['QUTE_FIFO'], 'w') as fifo:
#     fifo.write('open -t %s' % tmpfile)
