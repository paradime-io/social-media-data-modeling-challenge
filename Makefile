all: before_snapshot snapshot after_snapshot test

DAYS_TO_LOAD ?= 5

before_snapshot:
	dbt run --select tag:before_snapshot --vars '{"days_to_load": $(DAYS_TO_LOAD)}'

snapshot:
	dbt snapshot

after_snapshot:
	dbt run --select tag:after_snapshot --vars '{"days_to_load": $(DAYS_TO_LOAD)}'

test:
	dbt test