DATA := $(shell find data -type f)
DB := rentsafe.db

.DEFAULT_GOAL := dist

$(DB): data.db sql/rentsafe.sql
	sqlite3 -cmd "ATTACH '$<' AS data" $@ <sql/rentsafe.sql
	./bin/clean $@

data.db: data/registrations.csv data/evaluations.csv
	sqlite3 $@ -csv -cmd '.import data/evaluations.csv evaluation' .exit
	sqlite3 $@ -csv -cmd '.import data/registrations.csv registration' .exit

%.gz: $(DB)
	gzip --force --keep --stdout $< >$@

requirements.txt:
	uv pip compile pyproject.toml >requirements.txt

.PHONY: clean
clean:
	$(RM) -r $(DB) dist/

.PHONY: dist
dist:
	mkdir -p dist
	make dist/$(DB).gz
	cd dist && sha256sum *.gz >SHA256SUMS

.PHONY: fetch
fetch:
	./bin/fetch
