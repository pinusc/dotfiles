#!/usr/bin/env python
import itertools
import os
import sys

if len(sys.argv) != 2:
    print("Usage: anagrams.py WORD")
    sys.exit(1)


wordset = {}
dictionary_path = os.getenv('DICTIONARY_FILE', '/usr/share/dict/words')
with open(dictionary_path) as df:
    wordset = set([l.strip() for l in df.readlines()])

letters = sys.argv[1]

permutations = [''.join(w) for w in itertools.permutations(letters)]
permutations = set(permutations)


anagrams = [w for w in permutations if w in wordset and w != letters]

if len(anagrams) > 1 or letters not in anagrams:
    print(f'{letters}: ' + ' '.join(anagrams))
