## How to deploy

Install Ansible:
```
$ pip install ansible
```

Run the Ansible playbook to deploy to the staging server and prompt for `sudo` password and Ansible vault password:
```
$ ansible-playbook -i staging -K --vault-id @prompt site.yml
```

To load some initial data specify the extra variable `initial_data`:
```
$ ansible-playbook -i staging -K --vault-id @prompt --extra-vars "initial_data=../periodo-data/initial-data.json" site.yml 
```

To import a PeriodO export file (a gzipped SQL dump file) specify the extra variable `import_file`:
```
$ ansible-playbook -i staging -K --vault-id @prompt --extra-vars "import_file=../periodo-data/export.sql.gz" site.yml 
```

To import a PeriodO export directly from a public server specify the extra variable `import_url`:
```
$ ansible-playbook -i staging -K --vault-id @prompt --extra-vars "import_url=https://staging.perio.do/export.sql site.yml 
```

## Explanation of files

[`ansible.cfg`](ansible.cfg) is the [Ansible configuration file](http://docs.ansible.com/ansible/latest/intro_configuration.html)

[`staging`](staging) and [`production`](production) are [inventories](http://docs.ansible.com/ansible/latest/intro_inventory.html) of hosts to deploy to

[`site.yml`](site.yml) is the [playbook](http://docs.ansible.com/ansible/latest/playbooks.html)
