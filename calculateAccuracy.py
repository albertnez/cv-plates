#! /usr/bin/env python3
import glob

PLATES = [
    '*******',  # Dummy, to number them from 1 to n.
    '0945HVM',
    '1222HMC',
    '1993HXC',
    '2093GSW',
    '2837GLP',
    '3685HDP',
    '5134FFJ',
    '5406CWR',
    '5657GLM',
    '6220GNC',
    '7365CDF',
    '9211GMB',
    '9211GMB',
    '9935GLL',
    'AE123MK',
    'APTC69',
    'C260PB47',
    '5089bzv,',
]

NUM_PLATES = len(PLATES)

if __name__ == '__main__':

    for i in range(1, NUM_PLATES):
        f = glob.glob('plate{0}-*'.format(i))
        if not f:
            print('plate{0} which matches with {1} was not generated = 0'.format(i, PLATES[i]))
        else:
            f = f[0].replace('plate{0}-'.format(i),'')[:-4]
            sm = sum(map(lambda u : int(u[0] == u[1]), zip(f, PLATES[i])))
            print('Correct matches between plate{0}-{1} and {2} = {3}'.format(i, f, PLATES[i], sm))

