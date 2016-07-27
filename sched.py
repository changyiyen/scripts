#! usr/bin/python3
#-*- coding: utf-8 -*-

##import itertools
import io
import pprint

import random

# calendar slots
cal_l = list(range(21))*3
# dict of selected permutations
p = dict()
# global to hold current high score
hi_score = 0

def fill(x):
    d = (
        {x[0],x[3],x[6],x[9]}, # Douliou
        {x[1],x[4],x[7],x[10]},
        {x[2],x[5],x[8],x[11]},
        {x[12],x[15],x[18]}, # ICU
        {x[13],x[16],x[19]},
        {x[14],x[17],x[20]},
        {x[21],x[24]}, # ID
        {x[22],x[25]},
        {x[23],x[26]},
        {x[27],x[30]}, # GeneralMedicine
        {x[28],x[31]},
        {x[29],x[32]},
        {x[33],x[36]}, # Chest
        {x[34],x[37]},
        {x[35],x[38]},
        {x[39],x[42]}, # Nephro
        {x[40],x[43]},
        {x[41],x[44]},
        {x[45],x[48]}, # CV
        {x[46],x[49]},
        {x[47],x[50]},
        {x[51],x[54],x[57]}, # GI
        {x[52],x[55],x[58]},
        {x[53],x[56],x[59]},
        {x[60]}, # ThreeInOne
        {x[61]},
        {x[62]},
        )
    jun = set([x[i] for i in range(len(x)) if i % 3 == 0])
    jul = set([x[i] for i in range(len(x)) if i % 3 == 1])
    aug = set([x[i] for i in range(len(x)) if i % 3 == 2])
    #print(len(jun), len(jul), len(aug))
    if len(jun) != 21 or len(jul) != 21 or len(aug) != 21:
        return None
    else:
        return d

def calc(x):
    score = 0
    # ruleset
    ## blocks
    Douliou = x[0:12]
    ICU = x[12:21]
    ID = x[21:27]
    GeneralMedicine = x[27:33]
    Chest = x[33:39]
    Nephro = x[39:45]
    CV = x[45:51]
    GI = x[51:60]
    ThreeInOne = x[60:]
    # 1st priority: 10 points
    if 1 in CV:
        score += 10
    if 2 in GeneralMedicine:
        score += 10
    if 3 in ThreeInOne:
        score += 10
    if 4 in ID:
        score += 10
    if 5 in CV:
        score += 10
    if 6 in GI:
        score += 10
    if 7 in CV:
        score += 10
    if 8 in GI:
        score += 10
    if 9 in GI:
        score += 10
    if 10 in CV:
        score += 10
    if 11 in GI:
        score += 10
    if 12 in CV:
        score += 10
    if 13 in GI:
        score += 10
    if 14 in GI:
        score += 10
    if 15 in CV:
        score += 10
    if 16 in ID:
        score += 10
    if 17 in Nephro:
        score += 10
    if 18 in GI:
        score += 10
    if 19 in Nephro:
        score += 10
    # 2nd priority: 5 points
    if 1 in Nephro:
        score += 5
    if 2 in GI:
        score += 5
    if 3 in ID:
        score += 5
    if 4 in GI:
        score += 5
    if 5 in Nephro:
        score += 5
    if 6 in ID:
        score += 5
    if 7 in GI:
        score += 5
    if 8 in Nephro:
        score += 5
    if 9 in ID:
        score += 5
    if 10 in Nephro:
        score += 5
    if 11 in Nephro:
        score += 5
    if 12 in GI:
        score += 5
    if 13 in ID:
        score += 5
    if 14 in Chest:
        score += 5
    if 15 in Nephro:
        score += 5
    if 16 in Nephro:
        score += 5
    if 17 in Chest:
        score += 5
    if 18 in Chest:
        score += 5
    if 19 in CV:
        score += 5

    # unfinished score matrix...

    return score

# brute force search: will very likely expend all memory
##for x in itertools.permutations(cal_l):
# Monte Carlo search (maybe?)
for i in range(1000000):
    random.shuffle(cal_l)
    # check if combination valid
    temp = fill(cal_l)
    if not temp:
        continue
    score = calc(cal_l)
    # valid combinations go below
    if score > hi_score:
        p[score] = [t]
        hi_score = score
    if score == hi_score:
        p[score].append(t)

f = io.open('result.txt', mode='w')
pprint.pprint(p, stream=f, indent=4)
