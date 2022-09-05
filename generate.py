import argparse
from utils import *


K_lst = list(range(1,10)) + [chr(x) for x in range(ord('a'), ord('z')+1)] + [chr(x) for x in range(ord('A'), ord('Z')+1)]


class Dir(object):
    config = dict()
    short_name = str()

    def __init__(self, formula_1, formula_2, system, path):
        self.formula_1 = formula_1
        self.formula_2 = formula_2
        self.system = system
        l, k = analyze_path(path, formula_1, formula_2)
        if l:
            self.k = K_lst[k]
            self.name = f'{self.k}_{formula_1}+{formula_2}'
            self.path = os.path.join(path, self.name)
            os.mkdir(self.path)
            self.is_full = False
        else:
            self.name = k
            self.k = k[0]
            self.path = os.path.join(path, self.name)
            self.is_full = True

    def configure_uspex(self, add, factor, config_path, overwrite, root_dirname):
        numspecies = list()
        f1 = formula_to_tuple(self.formula_1)
        f2 = formula_to_tuple(self.formula_2)
        numspecies.append(list(f1) + [0])
        numspecies.append([0] + list(f2))
        if add:
            numspecies.append([0, 0] + [add])
        minat = sum(f1) + sum(f2) + add
        maxat = factor * minat
        self.config = {
            'calctype': 1,
            'system': self.system,
            'numspecies': numspecies,
            'minat': minat,
            'maxat': maxat
                  }
        self.config.update(set_config(config_path))
        input_txt = generate_input_txt(self.config)
        if os.path.isfile(os.path.join(self.path, 'INPUT.txt')) and not overwrite:
            print(f'File {os.path.join(self.path, "INPUT.txt")} already exists!')
        else:
            copy_sources(self.path)
            with open(os.path.join(self.path, 'INPUT.txt'), 'w') as f:
                f.write(input_txt)
            if root_dirname == '':
                abs_path = os.path.dirname(os.path.abspath(os.path.dirname(self.path)))
                root_dirname = f'{os.path.basename(abs_path)[0]}.{os.path.dirname(self.path)[0]}'
            self.short_name = f'{root_dirname}.{self.k}'
            with open(os.path.join(self.path, 'script_submit'), 'r') as f:
                file_data = f.read()
            with open(os.path.join(self.path, 'script_submit'), 'w') as f:
                f.write(file_data.replace('jobname', self.short_name))
            with open(os.path.join(self.path, 'Submission', 'submitJob_local.py'), 'r') as f:
                file_data = f.read()
            with open(os.path.join(self.path, 'Submission', 'submitJob_local.py'), 'w') as f:
                f.write(file_data.replace('USPEX', self.short_name))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', type=str, default='.', help='Path where generate folders')
    parser.add_argument('-b', nargs='+', default=[], help='Binary formulas on which generate')
    parser.add_argument('-t', choices=['fixcoms', 'varcomps', 'both'], default='both', help='Which calculation types to generate')
    parser.add_argument('-a', type=int, default=0, help='Additional composition block')
    parser.add_argument('-f', type=int, default=3, help='f = maxat / minat')
    parser.add_argument('-j', type=str, default='', help='.json with config')
    parser.add_argument('-o', type=boolean_string, default=False, help='Overwrite existing files and directories')
    parser.add_argument('-r', type=str, default='', help='Short root dirname')
    args = parser.parse_args()

    binary_lst = args.b
    binaries = dict()
    compositions = set()
    if not os.path.isdir(args.p):
        os.mkdir(args.p)

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
                d = Dir(formula_1, formula_2, system, args.p)
                d.configure_uspex(args.a, args.f, args.j, args.o, args.r)
            pass
    else:
        print(f'Error! Determined systems number is not equal to 2: {", ".join(keys)}')


if __name__ == '__main__':
    main()
