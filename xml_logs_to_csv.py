# example usage: xml_logs_to_csv.py ['re_pattern'] ... < file_in.xml > file_out.csv
# search for patterns in Heritrix output xml and convert it into simple csv

import sys
import re

# if sys.argv[0] == __file__.split('/')[-1]:
#     sys.argv.pop(0)

# print headers
print('"tag","value"')

search_pattern = ''
for arg in sys.argv[1:]:
    search_pattern = '|'.join([search_pattern, f"{arg}"])

search_pattern = search_pattern.removeprefix("|")

re_pattern = re.compile(search_pattern)

for line in sys.stdin:
    if re_pattern.search(line):
        l = line.removeprefix("<").removesuffix(">").split(">")
        try:
            print(f'"{l[0]}","{l[1].split("<")[0]}"')
        except:
            print(f'"BAD_WOLF","{l[0].rstrip()}"')

# print(search_pattern)