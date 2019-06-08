TARGET := staging
TARGET_SERVER := data.staging.perio.do

# TARGET := production
# TARGET_SERVER := data.perio.do

LEGACY_SERVER := aeshin
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

.PHONY: deploy-pre-renaming
deploy-pre-renaming: export.sql.gz
	cp -f $< ../
	ansible-playbook\
	 --ask-become-pass\
	 --vault-id=@prompt\
	 --inventory ../$(TARGET)\
	 --extra-vars="project_repo_version=pre-renaming"\
	 --extra-vars="import_file=$<"\
	 --extra-vars="admin_permissions=submit_patch,accept_patch,update_bag"\
	 ../periodo-server.yml

.PHONY: deploy
deploy: patch
	ansible-playbook\
	 --ask-become-pass\
	 --vault-id=@prompt\
	 --inventory ../$(TARGET)\
	 ../site.yml

.PHONY: patch
patch: periodo-validation-master\
 periodo-validation-master/shapes\
 periodo-validation-master/fix/node_modules\
 deploy-pre-renaming
	DATASET="https://$(TARGET_SERVER)/d.json" \
	CHANGES="$<" \
	./apply-changes\
	 whitelist-language-tags\
	 use-lexvo-uris\
	 broader\
	 derived-from\
	 expanded-context\
	 use-wikidata-for-spatial-coverage\
	 renaming

.PHONY: clean
clean:
	rm -rf periodo-validation-master
	rm -f *.sql *.sql.gz shapes
	rm -f ../export.sql.gz

.PHONY: all
all: deploy
