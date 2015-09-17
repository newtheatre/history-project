def fill_people_reverse_index(item, people_list, index_name, site)

  unless site.data.has_key?(index_name)
    site.data[index_name] = Hash.new
  end

  index = site.data[index_name]

  for person in people_list
    if person.has_key?("name") and person["name"] != "unknown"
      name = person["name"]
      role = person["role"]
      record_new = {"roles"=>[role], "item"=>item}

      if index.has_key?( name )
        # Existing RI record
        existing_record = index[name].detect { |r| r["item"] == item }
        if existing_record
          # If this person already has a role on this show, don't make a new record, just add the second/third.. role to a list
          existing_record["roles"].push(role)
        else
          # First role on this show
          index[name].push(record_new)
        end

      else
        # First RI record for this person
        index[name] = [record_new]
      end

    end
  end
end
