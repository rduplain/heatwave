## Development

Run Phoenix LiveView:

```
mix setup
mix test
iex -S mix phx.server
```

Separately, simulate HTTP clients:

```
mix heatwave.simulate
```

## Architecture

* Ingest data via HTTP.
  - X-API-KEY specifies which sensor, by name.
  - Data is simply a plaintext float.
  - Timestamp assumes client posted data immediately upon sensing.
* Save data to SQLite, for later offline review.
* Stream data to Chart.js live directly from pubsub upon ingest.

Temperature values are in degrees F, because that's how the human-facing
thermostats are configured. Time resolution is fuzzy, one or two seconds,
but temperature is a slow quantity.

Keep it simple.
