import os

years = range(1950, 2015)

def make_template(year, year_range, year_range_short):
    return """---
layout: page
group: show_year
sort: """ + year + """
title: """ + year_range + """
---

{% assign shows = site.collections.shows.docs | where:'year', """ + year_range_short + """ %}

{% include show_list.html %}

"""

for year in years:
  year_this = str(year) # 2012
  year_next = str(year+1) # 2013

  year_range = "{} - {}".format(year_this, year_next[2:]) # 2012 - 13
  year_range_short = "{}_{}".format(year_this[2:], year_next[2:])
  content = make_template(str(year), year_range, year_range_short)
  filename = "shows/{}.html".format(year_range_short)
  stream = open(filename, "w")
  stream.write(content)
  stream.close()
