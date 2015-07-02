# Console outputs a person list

import os
import csv

with open('tmp/person_list_input.csv') as csvfile:
    csvreader = csv.reader(csvfile)
    for row in csvreader:
        print """  - role: {}
    name: {}""".format(row[0], row[1])

