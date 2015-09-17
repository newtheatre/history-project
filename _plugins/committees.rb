module Jekyll
  class CommitteeDataGenerator < Jekyll::Generator
    priority :high

    def generate(site)
      puts "Processing committees..."
      committees = site.collections["committees"].docs
      committees_by_year = Hash.new

      for committee in committees
        year = committee.basename_without_ext

        committees_by_year[year] = committee

        committee.data["year"] = year

        if committee.data.has_key?("committee") and committee.data["committee"].class == Array
          fill_people_reverse_index(committee, committee.data["committee"], "people_ri_committees", site) end

        # Generate the legacy path for 301 redirect re. #142 Make semantic and pretty urls
        legacy_path = "committees/#{committee.basename_without_ext}.html"
        committee.data["redirect_from"] = legacy_path
      end

      site.data["committees_by_year"] = committees_by_year

    end
  end
end

