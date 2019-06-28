## Explanation of files

[`ansible.cfg`](ansible.cfg) is the [Ansible configuration file](http://docs.ansible.com/ansible/latest/intro_configuration.html)

[`testing`](testing), [`staging`](staging) and [`production`](production) are [inventories](http://docs.ansible.com/ansible/latest/intro_inventory.html) of hosts to deploy to

[`site.yml`](site.yml) is the [playbook](http://docs.ansible.com/ansible/latest/playbooks.html)

`site.yml` simply imports the playbooks [`periodo-server.yml`](periodo-server.yml), [`periodo-client.yml`](periodo-client.yml), and [`cors-proxy.yml`](cors-proxy.yml). If you wish to only deploy one of these, substitute the appropriate playbook file name for `site.yml` in the examples below.

## How to deploy

Install Ansible:
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

To deploy a specific version (git branch, tag, or commit hash) of the server specify the extra variable `project_repo_version`:

```sh
$ ansible-playbook \
--ask-become-pass \
--vault-id=@prompt \
--inventory staging \
--extra-vars "project_repo_version=pre-renaming" \
site.yml
```

To deploy a specific NPM package version of the client specify the extra variable `client_version`:

```sh
$ ansible-playbook \
--ask-become-pass \
--vault-id=@prompt \
--inventory staging \
--extra-vars "client_version=3.0.0-pre.2" \
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
