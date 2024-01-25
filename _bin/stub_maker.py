# Makes show stubs from a CSV file
# CSV MUST be in the format title, YY_YY, period, season_sort, season, playwright, date_start, date_end, content

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

def make_template(title, period, sort, season, playwright, date_start, date_end, content):
    return """---
title: \"""" + title + """\"
playwright: \"""" + playwright + """\"
period: """ + period + """
season: \"""" + season + """\"
season_sort: """ + sort + """
date_start: """ + date_start + """
date_end: """ + date_end + """
venue:
  - New Theatre
---

""" + content + """
"""

with open('tmp/stub_maker_input.csv') as csvfile:
    stubreader = csv.reader(csvfile)
    for row in stubreader:
        body = make_template(
            title=row[0],
            period=row[2],
            sort=row[3],
            season=row[4],
            playwright=row[5],
            date_start=row[6],
            date_end=row[7],
            content=row[8],
        )
        file_title = row[0].lower().replace(' ','_').replace("'",'').replace('&','').replace('.','_').replace('/','_').replace('(','_').replace(')','_').replace('__','_')

        mkdir_p("_shows/{}".format(row[1]))

        filename = "_shows/{}/{}.md".format(row[1], file_title)
        print "Writing {}".format(filename)
        stream = open(filename, "w")
        stream.write(body)
        stream.close()
