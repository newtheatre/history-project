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
    end

    def generate(site)
      Jekyll.logger.info "Generating people by..."

      # Collection hashes
      @people_by_crole  = Hash.new
      @people_by_award  = Hash.new
      @people_by_graduation_year = Hash.new


      site.data["people"].each { |person| people_iterator(person) }

      # Save generated arrays
      site.data["people_by_crole"] = @people_by_crole
      site.data["people_by_award"] = @people_by_award
      site.data["people_by_graduation_year"] = @people_by_graduation_year
    end
  end
end
