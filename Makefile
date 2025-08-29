all:
	echo "Run in one terminal:"
	echo
	echo "    make web"
	echo
	echo "Then in another:"
	echo
	echo "    make sim"
	echo

web:
	cd web; mix setup
	cd web; mix test
	cd web; iex -S mix phx.server # Ctrl-C Ctrl-C to exit.

sim:
	cd web; mix heatwave.simulate # Ctrl-C Ctrl-C to exit.

.PHONY: web
.SILENT:
