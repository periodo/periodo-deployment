## Explanation of files

[`ansible.cfg`](ansible.cfg) is the [Ansible configuration file](http://docs.ansible.com/ansible/latest/intro_configuration.html)

[`testing`](testing), [`staging`](staging) and [`production`](production) are [inventories](http://docs.ansible.com/ansible/latest/intro_inventory.html) of hosts to deploy to

[`site.yml`](site.yml) is the [playbook](http://docs.ansible.com/ansible/latest/playbooks.html)

## How to deploy

Install Ansible 2.5:
```
$ pip install ansible
```

Run the Ansible playbook to deploy to the staging server and prompt
for `sudo` password and Ansible vault password:

```sh
$ ansible-playbook \
--ask-become-pass \
--vault-id=@prompt \
--inventory staging \
site.yml
```

To deploy a specific version (branch, tag, or commit hash) specify the extra variable `project_repo_version`:

```sh
$ ansible-playbook \
--ask-become-pass \
--vault-id=@prompt \
--inventory staging \
--extra-vars "project_repo_version=pre-renaming" \
site.yml
```

To load some initial data specify the extra variable `initial_data`:

```sh
$ ansible-playbook \
--ask-become-pass \
--vault-id=@prompt \
--inventory staging \
--extra-vars "initial_data=../periodo-data/initial-data.json" \
site.yml
```

To import a PeriodO export file (a gzipped SQL dump file) specify the
extra variable `import_file`:

```sh
$ ansible-playbook \
--ask-become-pass \
--vault-id=@prompt \
--inventory staging \
--extra-vars "import_file=../periodo-data/export.sql.gz" \
site.yml
```

To import a PeriodO export directly from a public server specify the
extra variable `import_url`:

```sh
$ ansible-playbook \
--ask-become-pass \
--vault-id=@prompt \
--inventory staging \
--extra-vars "import_url=https://staging.perio.do/export.sql" \
site.yml
```

Change `--inventory staging` to `--inventory production` to deploy to production.

## Notes for migrating to UT Libraries

The [`Makefile`](migrate-from-legacy/Makefile) in `migrate-from-legacy` documents the planned process for migrating the production server to the UT Libraries:

1. __UNC__ will export legacy data from the production server and apply the necessary fixes ([details](https://github.com/periodo/periodo-deployment/blob/master/migrate-from-legacy/Makefile#L10-L29)).

1. __UT__ will deploy the [`pre-renaming`](https://github.com/periodo/periodo-server/tree/pre-renaming) version of `periodo-server` to production, using the exported data from step #1 ([details](https://github.com/periodo/periodo-deployment/blob/2be368124a54158b5f547950d3e3539a6d46877f/migrate-from-legacy/Makefile#L43-L49)).

1. __UNC__ will apply the necessary data patches to the production server ([details](https://github.com/periodo/periodo-deployment/blob/2be368124a54158b5f547950d3e3539a6d46877f/migrate-from-legacy/Makefile#L64-L72)).

1. __UT__ will deploy the latest version of `periodo-server` to production ([details](https://github.com/periodo/periodo-deployment/blob/2be368124a54158b5f547950d3e3539a6d46877f/migrate-from-legacy/Makefile#L53-L57)).
