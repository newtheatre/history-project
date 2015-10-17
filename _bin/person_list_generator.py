# Console outputs a person list

import os
import csv

with open('tmp/person_list_input.csv') as csvfile:
    csvreader = csv.reader(csvfile)
    for row in csvreader:
        stream = open('tmp/person_list_output.yml', 'a')
        stream.write( """  - role: {}\n    name: {}\n""".format(row[0], row[1])
        )
        stream.close()

