# EventFindr

EventFindr is a simple CLI used to find live entertainment events.

## Installation

Run 'bundle install' to install required gems.

```bash
bundle install
```

Create a file named 'api_key.rb' in the 'config' folder. Obtain an api key from ticketmaster [here](https://developer.ticketmaster.com/products-and-docs/apis/getting-started/). Once api key is obtained, assign the key to the global variable '$key' as a string in the 'api_key.rb' file.

Run 'rake db:migrate' in the root directory to create the database locally.

```bash
rake db:migrate
```


## Contributing
Contributions are welcome. Feel free to open a pull request or branch from this project.

## License
[MIT](https://choosealicense.com/licenses/mit/)
