#!/usr/bin/python
# coding: utf-8

"""
    Recursively searches for 'LICENSE.*' files and put them into a friendly plist. 

    usage: ./CreditsKit.py -s inputPath/ -o outputPath/FILENAME.plist
   
    See license: LICENSE for more details.
    Note: you must add the FILENAME.plist to your XCode project.

    THIS IS A MODIFIED VERSION - Original script available at: https://github.com/carloe/LicenseGenerator-iOS
"""

import os
import sys
import plistlib
import re
import codecs
from optparse import OptionParser
from optparse import Option, OptionValueError
from copy import deepcopy

VERSION = '0.1'
PROG = os.path.basename(os.path.splitext(__file__)[0])
DESCRIPTION = '''Recursively searches for 'LICENSE.*' files and put them into a friendly plist.'''

class MultipleOption(Option):
    ACTIONS = Option.ACTIONS + ("extend",)
    STORE_ACTIONS = Option.STORE_ACTIONS + ("extend",)
    TYPED_ACTIONS = Option.TYPED_ACTIONS + ("extend",)
    ALWAYS_TYPED_ACTIONS = Option.ALWAYS_TYPED_ACTIONS + ("extend",)

    def take_action(self, action, dest, opt, value, values, parser):
        if action == "extend":
            values.ensure_value(dest, []).append(value)
        else:
            Option.take_action(self, action, dest, opt, value, values, parser)


def main(argv):
    parser = OptionParser(option_class=MultipleOption,
                              usage='usage: %prog -s source_path -o output_plist -e [exclude_paths]',
                              version='%s %s' % (PROG, VERSION),
                              description=DESCRIPTION)
    parser.add_option('-s', '--source', 
                   type="string",
                  dest='inputpath', 
                  metavar='source_path', 
                  help='source directory to search for licenses')
    parser.add_option('-o', '--output-plist', 
                   type="string",
                  dest='outputfile', 
                  metavar='output_plist', 
                  help='path to the plist to be generated')
    parser.add_option('-e', '--exclude', 
                  action="extend", type="string",
                  dest='excludes', 
                  metavar='path1, ...', 
                  help='comma seperated list of paths to be excluded')
    if len(sys.argv) == 1:
        parser.parse_args(['--help'])

    OPTIONS, args = parser.parse_args()

    if(not os.path.isdir(OPTIONS.inputpath)):
        print "Error: Invalid source path: %s" % OPTIONS.inputpath
        sys.exit(2)

    if(not OPTIONS.outputfile.endswith('.plist')):
        print "Error: Outputfile must end in .plist"
        sys.exit(2)

    plist = plistFromDir(OPTIONS.inputpath, OPTIONS.excludes)
    plistlib.writePlist(plist,OPTIONS.outputfile)
    return 0

def plistFromDir(dir, excludes):
    """
    Recursilvely search from LICENSE files. 
    Folders with this file will be added to the plist.
    """
    plist = []
    os.chdir(sys.path[0])
    for root, dirs, files in os.walk(dir):
        for file in files:
            if file.startswith("LICENSE"):
                plistPath = os.path.join(root, file)
                if not excludePath(plistPath, excludes):
                    license = plistFromFile(plistPath)
                    plist.append(license)
    return plist

def plistFromFile(path):
    """
    Uses the name of the paremt folder for the title property.
    """
    base_group = {'Title': '','Text': ''}
    current_file = open(path, 'r')
    group = deepcopy(base_group)
    title = path.split("/")[-2]
    group['Title'] = unicode(title, 'utf-8')
    srcBody = current_file.read()
    body = ""
    for match in re.finditer(r'(?s)((?:[^\n][\n]?)+)', srcBody):
        body = body + re.sub("(\\n)", " ", match.group()) + "\n\n"
    body = unicode(body, 'utf-8')
    group['Text'] = rchop(body, " \n\n")
    return group
    
def excludePath(path, excludes):
    if excludes is None:
        return False
    for pattern in excludes:
        if(re.search(pattern, path, re.S) != None):
            return True
    return False
    
def rchop(str, ending):
    if str.endswith(ending):
        return str[:-len(ending)]
    return str

if __name__ == "__main__":
    main(sys.argv[1:])
