# Websocket input plugin for [Fluentd](https://github.com/fluent/fluentd)

fluent-plugin-in-websocket adds websocket as input in Fluentd

## Installation

Install your gem with fluent-plugin-gem or td-agent-gem (depending on what are you using):

```ruby
fluent-gem install fluent-plugin-in-websocket
td-agent-gem install fluent-plugin-in-websocket
```

## Usage

To use it as input in fluent you will have to add it to your fluent/td-agent config (host and port are default values).

```ruby
<source>
  @type websocket
  @id websocket
  host 127.0.0.1
  port 8080
</source>
```

Then when you are sending data to websocket, you have to supply label, and record. e.g. in javascript (for localhost)

```ruby
const ws = new WebSocket('ws://127.0.0.1:8080/');
const label = 'yourapp.somelabel';
const record = {'test': 1, 'some': {'nested': 2}};
const message = JSON.stringify({label, record});
ws.send(message);
```

## Development

I have created this gems for my needs. If you want, send me notice what more would you want in this plugin, or submit pull request.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
