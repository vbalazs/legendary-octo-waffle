# MTG client

## Setup and running the tests

    $ bundle install
    $ rake

## Usage

    $ ruby app.rb --help

```
Usage: app.rb [options]
        --task1                      Returns a list of Cards grouped by Set
        --task2                      Returns a list of Cards grouped by Set and then by rarity
        --task3                      Returns a list of cards from the Khans of Tarkir that ONLY                       have the colors red and blue
    -h, --help                       Prints this help
```

Since the response for the first two tasks can be huge, pipe it to a file :)
