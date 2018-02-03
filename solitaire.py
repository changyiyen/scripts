#!/usr/bin/python3

import sys
import io
import json
import string
import argparse

atoi_ciphertext = dict(zip(string.ascii_uppercase, range(1, 27)))
itoa_ciphertext = dict(zip(range(1, 27), string.ascii_uppercase))
atoi_plaintext = dict(zip(string.ascii_lowercase, range(1, 27)))
itoa_plaintext = dict(zip(range(1, 27), string.ascii_lowercase))

# Functions
def check_deck(deck):
    '''
    Checks if the deck is properly formed, i.e., total number of
    cards is 54, and all cards from 1 (ace of spades) to 54 (2nd joker)
    are present. If both conditions are satisfied, there shouldn't be
    duplicates or weird cards like non-integers (I think).
    Note that the joker cards are numbers 53 and 54 respectively.
    '''
    # check if number of cards is correct
    if len(deck) is not 54:
        raise Exception("Wrong number of cards")
    # check for missing cards
    for i in range(1,55):
        if i not in deck:
            raise Exception("Card not found in deck")

def gen_key():
    global k
    # step 1: move 1st joker (53) down 1 place
    i = k.index(53)
    k.remove(53)
    k.insert((i+1)%54, 53)
    # step 2: move 2nd joker (54) down 2 places
    i = k.index(54)
    k.remove(54)
    k.insert((i+2)%54, 54)
    # step 3: triple cut
    i = k.index(53)
    j = k.index(54)
    if i > j:
        i,j = j,i
    a = k[0:i]
    b = k[j+1:]
    k = b + k[i:j+1] + a
    # step 4: move number of cards indicated on bottom of deck from top
    # to just before bottom
    n = k[-1]
    if n == 53 or n == 54:
        n = 53
    k[-1:0] = k[0:n]
    k[0:n] = []
    # step 5: return key (card just below number of cards counted
    # from top, as indicated by top card)
    n = k[0]
    
    return k[n]

def encrypt(deck, stream_plain):
    s = ''
    for char in stream_plain:
        char_num = atoi_plaintext[char]
        char_num = (char_num + gen_key()) % 26
        s = s + itoa_ciphertext[char_num]
    return(s)

def decrypt(deck, stream_cipher):
    s = ''
    for char in stream_cipher:
        char_num = atoi_ciphertext[char]
        char_num = (char_num - gen_key()) % 26
        s = s + itoa_plaintext[char_num]
    return(s)
        
# Main program
parser = argparse.ArgumentParser(description="Solitaire cipher")
parser.add_argument('--key', '-k', help='Key file (in JSON format). Key consists of a list of integers ranging from 1 to 54, in which each integer appears once and only once.')
parser.add_argument('--file', '-f', help='File to work on. Consists of the letters of the English alphabet only. Non-alphabetical characters are ignored.')
parser.add_argument('--encrypt', '-e', action='store_true', help='Encrypt file.')
parser.add_argument('--decrypt', '-d', action='store_true', help='Decrypt file.')
args = parser.parse_args()

try:
    f = open(args.file, 'r')
except:
    print('Error reading data file', file=sys.stderr)
try:
    k = json.load(open(args.key, 'r'))
except:
    print('Not a valid JSON file', file=sys.stderr)

# Create stream of letters from file
stream = ''
for line in f:
    for c in line:
        if c not in string.ascii_letters:
            continue
        stream = stream + c

if args.encrypt:
    stream = stream.lower()
    print(encrypt(k, stream))
if args.decrypt:
    stream = stream.upper()
    print(decrypt(k, stream))
