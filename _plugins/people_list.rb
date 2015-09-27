def fill_people_reverse_index(item, people_list, index_name, site)

  # Create the RI for this case if first time
  unless site.data.has_key?(index_name)
    site.data[index_name] = Hash.new
  end

  # Create the array for people names if first time
  unless site.data.has_key?('people_names')
    site.data['people_names'] = Array.new
  end

  index = site.data[index_name]

  for person in people_list
    if (person.has_key?("name") and person["name"] != "unknown") and not person["person"] == false
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

      # Push name onto master name list
      unless site.data['people_names'].include? name
        site.data['people_names'].push name
      end

    end
  end
end

def make_hp_path(title)
  # Downcase, remove specials, space->underscore
  title.downcase.gsub(/[^0-9a-z \-]/i, '').gsub(' ','_')
end

module Jekyll
  class PersonURLTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super
      @markup = markup
    end

    def render(context)
      # Render any liquid variables in tag arguments and unescape template code
      render_markup = Liquid::Template.parse(@markup).render(context).gsub(/\\\{\\\{|\\\{\\%/, '\{\{' => '{{', '\{\%' => '{%')

      filename = make_hp_path(render_markup)
      "/people/#{filename}/"
    end
  end
end

Liquid::Template.register_tag('person_url', Jekyll::PersonURLTag)
