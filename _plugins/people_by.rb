require 'set'

module Jekyll
  class PeopleByGenerator < Jekyll::Generator
    priority :lowest

    def people_iterator(person)
      if person.data["shows"]
        # If had shows
        for record in person.data["shows"]
          # Loop through each show with involvement
          for role in record["roles"]
            # Loop through each role in show
            if @role_map.key?(role)
              # If we recognise the role, map and save involvement in srole
              # Use set to avoid duplicates
              (@people_by_srole[@role_map[role]] ||= Set.new) << person
            end
          end
        end
      end

      if person.data["committees"]
        # If was on committee
        for record in person.data["committees"]
          # Loop through each committee (single year)
          for role in record["roles"]
            # Loop through each role on that committee, and save in crole
            # Use set to avoid duplicates
            (@people_by_crole[role] ||= Set.new) << person unless role == "unknown"
          end
        end
      end

      if person.data["award"] and person.data["award"].size > 0
        (@people_by_award[person.data["award"]] ||= []) << person
      end

      # Only include people who have actually graduated
      if person.data["graduated"] and person.data["graduated"] < @year_end + 1
        (@people_by_graduation_year[person.data["graduated"]] ||= []) << person
      end

      if person.data["careers"] and person.data["careers"].class == Array
        for item in person.data["careers"]
          (@people_by_career[item] ||= []) << person
        end
      elsif person.data["careers"] and person.data["careers"].class == String
        (@people_by_career[person.data["careers"]] ||= []) << person
      end

      if person.data["course"] and person.data["course"].class == Array
        for item in person.data["course"]
          (@people_by_course[item] ||= []) << person
        end
      elsif person.data["course"] and person.data["course"].class == String
        (@people_by_course[person.data["course"]] ||= []) << person
      end

      (@people_by_letter[person.data["surname"][0].upcase] ||= []) << person
    end

    def generate(site)
      Jekyll.logger.info "Generating people by..."

      @year_end = site.config['year_end']
      @role_map = site.data['role-map'].to_liquid

      # Collection hashes
      @people_by_srole  = Hash.new
      @people_by_crole  = Hash.new
      @people_by_award  = Hash.new  # replaced by award.rb AwardDataGenerator
      @people_by_graduation_year = Hash.new
      @people_by_career = Hash.new
      @people_by_course = Hash.new
      @people_by_letter = Hash.new

      # Fill graduation year hash
      (site.config["year_start"]..site.config["year_end"]).each do |n|
        @people_by_graduation_year[n] = []
      end

      site.data["people"].each { |person| people_iterator(person) }

      # Sort people alpha under each letter
      # sort_people from people.rb
      @people_by_graduation_year.each_value { |v| v.sort!(&method(:sort_people)) }
      @people_by_letter.each_value { |v| v.sort!(&method(:sort_people)) }

      # Sets need converting to arrays, liquid falls over with sets
      @people_by_srole.each do |k,v|
        @people_by_srole[k] = v.to_a
      end
      @people_by_crole.each do |k,v|
        @people_by_crole[k] = v.to_a
      end

      # Save sorted hashes
      site.data["people_by_srole"] = @people_by_srole.sort.to_h
      site.data["people_by_crole"] = @people_by_crole.sort.to_h
      site.data["people_by_award"] = @people_by_award
      site.data["people_by_graduation_year"] = @people_by_graduation_year.sort.to_h
      site.data["people_by_career"] = @people_by_career.sort.to_h
      site.data["people_by_course"] = @people_by_course.sort.to_h
      site.data["people_by_letter"] = @people_by_letter.sort.to_h

    end
  end
end
