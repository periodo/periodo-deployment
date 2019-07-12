ANSIBLE_BIN := ansible-playbook

FULL_PLAYBOOK := site.yml
SERVER_PLAYBOOK := periodo-server.yml
CLIENT_PLAYBOOK := periodo-client.yml
CORS_PROXY_PLAYBOOK := cors-proxy.yml

EXTRA_VARS :=
INVENTORY ?= staging

ifdef SERVER_VERSION
	EXTRA_VARS += 'project_repo_version=$(SERVER_VERSION)'
endif

ifdef CLIENT_VERSION
	EXTRA_VARS += 'client_version=$(CLIENT_VERSION)'
endif

ifdef INITIAL_DATA
	EXTRA_VARS += 'initial_data=$(INITIAL_DATA)'
else ifdef IMPORT_FILE
	EXTRA_VARS += 'import_file=$(IMPORT_FILE)'
else ifdef IMPORT_URL
	EXTRA_VARS += 'import_url=$(IMPORT_URL)'
endif


ANSIBLE_ARGS := \
	--ask-become-pass \
	--vault-id=@prompt \
	--inventory $(INVENTORY) \
	--extra-vars=\"$(EXTRA_VARS)\"

help:
	@echo
	@echo Commands:
	@echo
	@echo "  \033[1mdeploy\033[0m"
	@echo "  Deploy all components (server, client, CORS proxy)"
	@echo
	@echo "  \033[1mdeploy-server\033[0m, \033[1mdeploy-client\033[0m, \033[1mdeploy-cors-proxy\033[0m"
	@echo "  Deploy individual components"
	@echo
	@echo "Environment variables:"
	@echo
	@echo "  \033[1mINVENTORY\033[0m (default: staging)"
	@echo "  The ansible inventory to deploy to. Valid options are 'staging' or 'production'"
	@echo
	@echo "  \033[1mSERVER_VERSION\033[0m"
	@echo "  The specific version of the server to deploy (git commit-ish)"
	@echo
	@echo "  \033[1mCLIENT_VERSION\033[0m"
	@echo "  The specific version of the client to deploy (npm package version)"
	@echo
	@echo "  \033[1mINITIAL_DATA\033[0m"
	@echo "  A JSON file of a PeriodO dataset to be used to initially populate the server"
	@echo
	@echo "  \033[1mIMPORT_FILE\033[0m"
	@echo "  A gzipped SQL file to be used as the database on the server"
	@echo
	@echo "  \033[1mIMPORT_URL\033[0m"
	@echo "  A URL pointing to a SQL file to be used as the database on the server"
	@echo
	@echo "Examples:"
	@echo
	@echo "  Deploy all components to production, using a specific version of the client:"
	@echo
	@echo "    INVENTORY=production CLIENT_VERSION=4.0.1 make deploy"
	@echo
	@echo "  Deploy the server to staging using an existing database"
	@echo
	@echo "    IMPORT_URL='https://data.perio.do/export.sql' make deploy-server"
	@echo


deploy:
	$(ANSIBLE_BIN) $(ANSIBLE_ARGS) $(FULL_PLAYBOOK)

deploy-server:
	$(ANSIBLE_BIN) $(ANSIBLE_ARGS) $(SERVER_PLAYBOOK)

deploy-client:
	$(ANSIBLE_BIN) $(ANSIBLE_ARGS) $(CLIENT_PLAYBOOK)

deploy-cors-proxy:
	$(ANSIBLE_BIN) $(ANSIBLE_ARGS) $(CORS_PROXY_PLAYBOOK)
