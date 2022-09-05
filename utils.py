import re
import os


def analyze_path(path, formula_1, formula_2):
    f = True
    for dirname in sorted(os.listdir(path)):
        if formula_1 in dirname and formula_2 in dirname:
            print(f'{dirname} is already created')
            f = False
            break
    if f:
        k_lst = list()
        for dirname in sorted(os.listdir(path)):
            k_lst.append(dirname[0])
            
    else:
        return '0'





def system_from_binaries(binaries):
    keys = list(binaries.keys())
    system = list()
    system.append(keys[0].split('-')[0])
    system.append(keys[1].split('-')[0])
    assert keys[0].split('-')[1] == keys[1].split('-')[1]
    system.append(keys[1].split('-')[1])
    return system


def boolean_string(s):
    if s not in {'False', 'True'}:
        raise ValueError('Not a valid boolean string')
    return s == 'True'


def formula_to_tuple(formula):
    coeffs = list()
    for each in re.findall('[A-Z][^A-Z]*', formula):
        coeff = ''.join([i for i in each if not i.isalpha()])
        if coeff == '':
            coeff = 1
        else:
            coeff = int(coeff)
        coeffs.append(coeff)
    coeffs = tuple(coeffs)
    return coeffs


def generate_input_txt(config):
    numspecies = list()
    for row in config['numspecies']:
        row_str = str()
        for each in row:
            row_str = row_str + str(each)
        numspecies.append(row_str)
    numspecies = '\n'.join(numspecies)
    input_txt = f"""PARAMETERS EVOLUTIONARY ALGORITHM
******************************************
*      TYPE OF RUN AND SYSTEM            *
******************************************
USPEX : calculationMethod (USPEX, VCNEB, META)
{config['calctype']}   : calculationType (dimension: 0-3; molecule: 0/1; varcomp: 0/1)
1     : AutoFrac

% optType
1
% EndOptType

% atomType
{config['system'][0]} {config['system'][1]} {config['system'][2]}
% EndAtomType

% numSpecies
{numspecies}
% EndNumSpecies

{config['minat']}  : minAt
{config['maxat']} : maxAt

******************************************
*               POPULATION               *
******************************************
{config['popsize']} : populationSize (how many individuals per generation)
{config['initpopsize']} : initialPopSize
{config['numgen']} : numGenerations (how many generations shall be calculated)
{config['stopcrit']} : stopCrit
0     : reoptOld
0.6   : bestFrac
******************************************
*          VARIATION OPERATORS           *
******************************************
{config['heredity']} : fracGene (fraction of generation produced by heredity)
{config['rand']} : fracRand (fraction of generation produced randomly from space groups)
{config['atomsmut']} : fracAtomsMut (fraction of the generation produced by softmutation)
{config['trans']} : fracTrans
{config['latmut']} : fracLatMut (fraction of the generation produced by softmutation)
{config['perm']} : fracPerm
*****************************************
*   DETAILS OF AB INITIO CALCULATIONS   *
*****************************************
% abinitioCode
1 1 1 1 1 1
% ENDabinit

% KresolStart
0.13 0.11 0.09 0.07 0.05 0.04
% Kresolend

% commandExecutable
mpirun vasp_std
% EndExecutable

1       : whichCluster (0: no-job-script, 1: local submission, 2: remote submission)
{config['numpar']}      : numParallelCalcs
{config['press']}     : ExternalPressure
"""
    return input_txt
