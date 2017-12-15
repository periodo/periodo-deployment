## How to deploy

Install Ansible:
```
$ pip install ansible
```

Get the `secrets.py` file for PeriodO and put it in a subdirectory called `secrets`:
```
$ cd periodo-server/
$ mkdir secrets
$ mv /from/somewhere/secrets.py secrets/
```

Run the Ansible playbook to deploy to the host `staging.perio.do` and prompt for `sudo` password:
```
$ cd periodo-server/
$ ansible-playbook -l staging.perio.do -K deploy.yml 
```

To load some initial data specify the extra variable `initial_data`:
```
$ cd periodo-server/
$ ansible-playbook -l staging.perio.do -K --extra-vars "initial_data=../periodo-data/initial-data.json" deploy.yml 
```

## Explanation of files

[`ansible.cfg`](periodo-server/ansible.cfg) is the [Ansible configuration file](http://docs.ansible.com/ansible/latest/intro_configuration.html)

[`inventory.ini`](periodo-server/inventory.ini) is the [inventory](http://docs.ansible.com/ansible/latest/intro_inventory.html) of hosts to deploy to

[`deploy.yml`](periodo-server/deploy.yml) is the [playbook](http://docs.ansible.com/ansible/latest/playbooks.html)

[`vars.yml`](periodo-server/vars.yml) defines the playbook [variables](http://docs.ansible.com/ansible/latest/playbooks_variables.html)

[`templates`](periodo-server/templates) contains Jinja2 templates for the nginx and uwsgi configurations



