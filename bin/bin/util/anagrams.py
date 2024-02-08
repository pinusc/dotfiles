#!/usr/bin/env python
import itertools

wordset = {}
with open('/usr/share/dict/words') as df:
    wordset = set([l.strip() for l in df.readlines()])

letters = input("Word to anagram: ")
permutations = [''.join(w) for w in itertools.permutations(letters)]
print()

anagrams = [w for w in permutations if w in wordset]

print("Found anagrams:")
print('\n'.join(anagrams))
