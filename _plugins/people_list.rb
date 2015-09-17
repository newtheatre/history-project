def fill_people_reverse_index(show, people_list, site)

  unless site.data.has_key?("people_ri")
    site.data["people_ri"] = Hash.new
  end

  people_ri = site.data["people_ri"]

  for person in people_list
    if person.has_key?("name") and person["name"] != "unknown"
      if people_ri.has_key?( person["name"] )
        people_ri[ person["name"] ].push(show) unless people_ri[ person["name"] ].include?(show)
      else
        people_ri[ person["name"] ] = [show]
      end
    end
  end
end
