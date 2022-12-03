### program to import network tuple files and convert to Directed unsigned class
import torch
from torch_geometric.data import Data
import argparse


#Define arguments for each required and optional input
def define_arguments():
    parser=argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    ## Required inputs
    parser.add_argument("--input-dir",dest="InputDir",required=True,help="InputDir")
    return parser

# Wrapper function
def generate_arguments(parser):

    #Generate argument parser and define arguments
    parser = define_arguments()
    args = parser.parse_args()

    input_dir = args.InputDir   
    return input_dir

def loadgraphs(input_dir):
    




