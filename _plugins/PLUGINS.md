# Plugins

## Runtime Order

The order generators run is important. Stuff made by one is only available to
plugins run after it.

### highest
- YearGenerator

### high
- ShowDataGenerator
- CommitteeDataGenerator

### normal
- PeoplePlaceholderGenerator

### low
- PeopleDataGenerator

### lowest
- AssetDataGenerator
- YearDataGenerator
