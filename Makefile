#!make

# This Makefile ALLOWS the following usage -> "make migration <name>"
# Normally, this is not the case in Makefiles, usually it's -> "make migrations name=<name>"
# http://bit.ly/37TR1r2

include secrets.env

VOLUME=$(PWD)/migrations:/migrations
USER_PASS_HOST=$(POSTGRES_USER):$(POSTGRES_PASSWORD)@localhost
URL=postgres://$(USER_PASS_HOST):7557/$(POSTGRES_DB)?sslmode=disable
SUCCESS=[ done "\xE2\x9C\x94" ]

ifeq (migration,$(firstword $(MAKECMDGOALS)))
  name := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(name):;@:)
endif

ifeq ($(firstword $(MAKECMDGOALS)),$(filter $(firstword $(MAKECMDGOALS)),up down))
  num := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(num):;@:)
  # When we migrate down without a number the number defaults to 1.
  # In other words, if we do "make down" rather than "make down <number>".
  # Note: migrating up without a number "make up" has no default on purpose to migrate to the latest migration.
  # Therefore, you must specifically provide a number to prevent this -- "make up <number>"
  ifndef num
    ifeq (down,$(firstword $(MAKECMDGOALS)))
      num := 1
    endif
  endif
endif

# Friendly messages are printed as you migrate. 
# You will be informed if you reach the oldest or latest migration available.

migration: 
	@docker run --volume $(VOLUME) --network host migrate/migrate \
	create \
	-ext sql \
	-dir /migrations \
	-seq $(name)

up:
	@docker run --volume $(VOLUME) --network host migrate/migrate \
	-path /migrations \
	-verbose \
	-database $(URL) up $(num) \
	&& echo $(SUCCESS) Successully migrated! \
	|| echo $(SUCCESS) Already migrated to latest migration! 1>&2

down:
	@docker run --volume $(VOLUME) --network host migrate/migrate \
	-path /migrations  \
	-verbose \
	-database $(URL) down $(num) \
	&& echo $(SUCCESS) Successully downgraded! \
	|| echo $(SUCCESS) Already downgraded from very first migration! 1>&2

.PHONY: up
.PHONY: down
.PHONY: migrations