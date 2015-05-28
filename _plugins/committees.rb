module Jekyll
  class CommitteeDataGenerator < Jekyll::Generator
    priority :high

    def generate(site)
      committees = site.collections["committees"].docs
      committees_by_year = Hash.new

      for committee in committees
        year = committee.basename_without_ext

        committees_by_year[year] = committee

        committee.data["year"] = year
      end

      site.data["committees_by_year"] = committees_by_year

    end
  end
end

