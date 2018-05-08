LEGACY_SERVER := aeshin
STAGING_SERVER := staging.perio.do
LEGACY_DB := /home/ptgolden/periodo/src/db.sqlite
FIX_PERMS := s|\["action", "submit-patch"\]|\
\["action", "submit-patch"\], \["action", "create-bag"\]|g
CHANGES_REPO := https://github.com/periodo/periodo-validation

legacy-export.sql.gz:
	ssh $(LEGACY_SERVER) 'sqlite3 $(LEGACY_DB) .dump | gzip > $@'
	scp $(LEGACY_SERVER):$@ .

fixed-orcids.sql: legacy-export.sql.gz
	gzcat $< | sed -e 's|http://orcid.org|https://orcid.org|g' > $@

fixed-permissions.sql: fixed-orcids.sql
	sed -e '$(FIX_PERMS)' $< > $@

export.sql.gz: fixed-permissions.sql
	gzip -c $< > $@

periodo-validation-master:
	curl -L '$(CHANGES_REPO)/archive/master.tar.gz' | tar -zx

periodo-validation-master/shapes:
	ln -f -s ../../../periodo-server/shapes $@

periodo-validation-master/fix/node_modules:
	cd periodo-validation-master/fix && npm install

.PHONY: deploy
deploy: export.sql.gz
	cp -f $< ../periodo-server/
	ansible-playbook\
	 -K\
	 -i ../periodo-server/inventory.ini\
	 -l $(STAGING_SERVER)\
	 -e "import_file=$<"\
	 ../periodo-server/deploy.yml

.PHONY: patch
patch: periodo-validation-master\
 periodo-validation-master/shapes\
 periodo-validation-master/fix/node_modules\
 deploy
	DATASET="https://$(STAGING_SERVER)/d.json" \
	CHANGES="$<" \
	./apply-changes\
	 whitelist-language-tags\
	 use-lexvo-uris\
	 broader-narrower\
	 derived-from\
	 expanded-context

.PHONY: clean
clean:
	rm -rf periodo-validation-master
	rm -f *.sql *.sql.gz shapes
