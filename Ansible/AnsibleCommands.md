js

Commands to execute playbooks : 

/usr/bin/ansible-playbook -i srvlist uninstall.yml
/usr/bin/ansible-playbook -i srvlist Newuninstall.yml


1. ansible --version
2.


| S.No | Command                                       | Description                                                                                              |
| ------ | ----------------------------------------------- | :--------------------------------------------------------------------------------------------------------- |
| 1    | ansible --version                             | Displays the version of the Ansible                                                                      |
| 2    | ansible -i inv -m "shell" -a "hostname"       | Runs hostname command at ip's mentioned in the inv file.<br />-m is a Module and -a : Arguments          |
| 3    | ansible -i inv webserver -m "shell" -a "date" | webserver is a tag which has all server details.                                                         |
| 4    | ansible-playbook -i env PlayBookName.yml      | Runs a playbook file.                                                                                    |
| 5    | ansible-playbook -i env -vvv PlayBookName.yml | -vvv : Runs in a verbose mode.                                                                           |
| 6    | ansible-galaxy role init kuber                | Creates entire structure of the Kuber. It will have files, tasks, tests, vars.. Entire folder structure. |
| 7    |                                               |                                                                                                          |
| 8    |                                               |                                                                                                          |
| 9    |                                               |                                                                                                          |
| 10   |                                               |                                                                                                          |
| 11   |                                               |                                                                                                          |
| 12   |                                               |                                                                                                          |
| 13   |                                               |                                                                                                          |
| 14   |                                               |                                                                                                          |
| 15   |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
|      |                                               |                                                                                                          |
