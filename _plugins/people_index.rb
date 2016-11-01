require 'set'

module PeopleIndex
  class PeopleIndex
    def initialize(people_docs)
      @people_docs = people_docs
    end

    def to_liquid
      @people_docs.map do |item|
        Person.new(item)
      end
    end
  end

  class Person
    def initialize(person)
      @person = person
    end

    def roles(set)
      roles = Set.new
      for ri in set
        for role in ri['roles']
          roles << role unless role.nil? or role == "unknown"
        end
      end
      return roles.to_a
    end

    def to_liquid
      {
        'url' => @person.url,
        'title' => @person.data['title'],
        'forename' => @person.data['forename'],
        'surname' => @person.data['surname'],
        'graduated' => @person.data['graduated'],
        'course' => Array(@person.data['course']),
        'awards' => Array(@person.data['award']),
        'careers' => Array(@person.data['careers']),
        'sroles' => roles(@person.data['shows']),
        'croles' => roles(@person.data['committees']),

        'headshot' => @person.data['headshot'],
      }
    end
  end
end
