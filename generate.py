import argparse
import re
import os

from utils import *


K_lst = list(range(1,10)) + [chr(x) for x in range(ord('a'), ord('z')+1)] + [chr(x) for x in range(ord('A'), ord('Z')+1)]


class Dir(object):

    def __init__(self, formula_1, formula_2, system, path):
        self.formula_1 = formula_1
        self.formula_2 = formula_2
        self.system = system
        self.k =
        self.name = f'{k}_{formula_1}+{formula_2}'
        self.path = os.path.join(path, self.name)

    def configure_uspex(self):

        config = {''}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--path', type=str, default='examples', help='Path where generate folders')
    parser.add_argument('-b', nargs='+', default=[], help='Binary formulas on which generate')
    parser.add_argument('--type', choices=['fixcoms', 'varcomps', 'both'], default='both', help='which calculation types to generate')
    parser.add_argument('-a', type=int, default=0, help='Additional composition block')
    args = parser.parse_args()

    binary_lst = args.b
    binaries = dict()
    compositions = set()
    if not os.path.isdir(args.path):
        os.mkdir(args.path)

    for formula in binary_lst:
        split = re.findall('[A-Z][^A-Z]*', ''.join([i for i in formula if not i.isdigit()]))
        split = '-'.join(split)
        if split not in binaries.keys():
            binaries[split] = list()
    keys = list(binaries.keys())
    if len(keys) == 2:
        print(f'Found 2 binary systems: {keys[0]} and {keys[1]}')
        for formula in binary_lst:
            split = re.findall('[A-Z][^A-Z]*', ''.join([i for i in formula if not i.isdigit()]))
            split = '-'.join(split)
            binaries[keys[keys.index(split)]].append(formula)
        for key in keys:
            binaries[key] = sorted(binaries[key])
        system = system_from_binaries(binaries)
        print(f'Found binary formulas: {binaries} of system {"-".join(system)}')
        for formula_1 in binaries[keys[0]]:
            for formula_2 in binaries[keys[1]]:
                d = Dir(formula_1, formula_2, system, args.path, k_lst[i])
                # print(d.name)
            pass
    else:
        print(f'Error! Determined systems number is not equal to 2: {", ".join(keys)}')


if __name__ == '__main__':
    main()
