all: phx

phx:
	cd web; mix setup
	cd web; mix test
	cd web; iex -S mix phx.server # Ctrl-C Ctrl-C to exit.
