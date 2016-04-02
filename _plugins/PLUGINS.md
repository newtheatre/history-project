# Plugins

## Runtime Order

The order generators run is important. Stuff made by one is only available to
plugins run after it. Honestly this is starting to get very bodge, as there are
only five levels we don't get fine grained control over the run order.

### highest
- YearGenerator

### high
- ShowDataGenerator
- CommitteeDataGenerator

### normal
- PeoplePlaceholderGenerator
- ShowsByGenerator

### low
- PeopleDataGenerator
- YearDataGenerator
- VenueGenerator
- SeasonGenerator

### lowest
- AssetDataGenerator
- YearGraphGenerator
- PeopleByGenerator
- AwardDataGenerator
