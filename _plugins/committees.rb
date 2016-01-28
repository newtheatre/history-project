module Jekyll
  class CommitteeDataGenerator < Jekyll::Generator
    priority :high

    # From years.rb
    def years_by_slug
      @years_by_slug ||= generate_years_by_slug(@years)
    end

    # From people.rb
    def people_by_filename
      @people_by_filename ||= generate_people_by_filename(@people)
    end

    def get_committee_legacy_paths(committee)
      "committees/#{committee.basename_without_ext}.html"
    end

    def generate_committee(committee)
      year = committee.basename_without_ext
      @committees_by_year[year] = committee
      committee.data["year"] = year
      committee.data["year_page"] = years_by_slug[year]

      if committee.data.key?("committee") and committee.data["committee"].class == Array
        committee.data["committee"] = parse_person_list(committee.data["committee"], people_by_filename)
        fill_people_reverse_index(committee, committee.data["committee"], "people_ri_committees", @site) end


      # Generate the legacy path for 301 redirect re. #142 Make semantic and pretty urls
      committee.data["redirect_from"] = get_committee_legacy_paths(committee)
    end

    def generate(site)
      Jekyll.logger.info "Processing committees..."

      @site = site
      @years = @site.collections["years"].docs

      committees = @site.collections["committees"].docs
      @committees_by_year = Hash.new

      @people = @site.collections["people"].docs

      committees.each { |committee| generate_committee(committee) }

      @site.data["committees_by_year"] = @committees_by_year

    end
  end
end

