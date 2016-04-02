module Jekyll
  class PeopleByGenerator < Jekyll::Generator
    priority :lowest

    def people_iterator(person)
      if person.data["committees"]
        # If was on committee
        for record in person.data["committees"]
          # Loop through each committee (single year)
          for role in record["roles"]
            # Loop through each role on that committee
            (@people_by_crole[role] ||= []) << person
          end
        end
      end

      if person.data["award"]
        (@people_by_award[person.data["award"]] ||= []) << person
      end

      if person.data["graduated"]
        (@people_by_graduation_year[person.data["graduated"]] ||= []) << person
      end

      (@people_by_letter[person.data["surname"][0].upcase] ||= []) << person
    end

    def generate(site)
      Jekyll.logger.info "Generating people by..."

      # Collection hashes
      @people_by_crole  = Hash.new
      @people_by_award  = Hash.new
      @people_by_graduation_year = Hash.new
      @people_by_letter = Hash.new

      site.data["people"].each { |person| people_iterator(person) }

      # Sort people alpha under each letter
      # sort_people from people.rb
      @people_by_letter.each_value { |v| v.sort!(&method(:sort_people)) }

      # Save sorted hashes
      site.data["people_by_crole"] = @people_by_crole.sort.to_h
      site.data["people_by_award"] = @people_by_award
      site.data["people_by_graduation_year"] = @people_by_graduation_year.sort.to_h
      site.data["people_by_letter"] = @people_by_letter.sort.to_h

    end
  end
end
