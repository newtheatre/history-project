# Makes show stubs from a CSV file
# CSV MUST be in the format title, YY_YY, period, season_sort

import os
import errno
import csv

def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc: # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else: raise

def make_template(title, period, sort):
    return """---
title: \"""" + title + """\"
playwright:
period: """ + period + """
season: In House
season_sort: """ + sort + """
venue:
  - New Theatre
---
"""

with open('tmp/stub_maker_input.csv') as csvfile:
    stubreader = csv.reader(csvfile)
    for row in stubreader:
        body = make_template(row[0], row[2], row[3])
        file_title = row[0].lower().replace(' ','_').replace("'",'').replace('&','').replace('.','_').replace('/','_').replace('(','_').replace(')','_').replace('__','_')

        mkdir_p("_shows/{}".format(row[1]))

        filename = "_shows/{}/{}.md".format(row[1], file_title)
        print "Writing {}".format(filename)
        stream = open(filename, "w")
        stream.write(body)
        stream.close()
