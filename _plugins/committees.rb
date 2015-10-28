module Jekyll
  class CommitteeDataGenerator < Jekyll::Generator
    priority :high

    def get_committee_legacy_paths(committee)
      "committees/#{committee.basename_without_ext}.html"
    end

    def generate_committee(committee)
      year = committee.basename_without_ext
      @committees_by_year[year] = committee
      committee.data["year"] = year

      if committee.data.has_key?("committee") and committee.data["committee"].class == Array
        fill_people_reverse_index(committee, committee.data["committee"], "people_ri_committees", @site) end

      # Generate the legacy path for 301 redirect re. #142 Make semantic and pretty urls
      committee.data["redirect_from"] = get_committee_legacy_paths(committee)
    end

    def generate(site)
      puts "Processing committees..."

      @site = site
      committees = @site.collections["committees"].docs
      @committees_by_year = Hash.new

      committees.each { |committee| generate_committee(committee) }

      @site.data["committees_by_year"] = @committees_by_year

    end
  end
end

