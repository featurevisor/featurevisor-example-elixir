.PHONY: install format compile test run check

install:
	mix deps.get

format:
	mix format --check-formatted

compile:
	mix compile --warnings-as-errors

test:
	mix test

run:
	mix run -e 'FeaturevisorExampleElixir.run()'

check: install format compile test
