# Домашнее задание к занятию "08.04 Создание собственных modules"

## Основная часть

1. В виртуальном окружении создаю новый `my_own_module.py` файл
```python
#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type
import os
from ansible.mpdule_utils._text import to_bytes

DOCUMENTATION = r'''
---
module: my_test

short_description: This is my test module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    name:
        description: This is the message to send to the test module.
        required: true
        type: str
    new:
        description:
            - Control to demo if the result of this module is changed or not.
            - Parameter description can be a list as well.
        required: false
        type: bool
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name

author:
    - Your Name (@yourGitHubHandle)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_namespace.my_collection.my_test:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_namespace.my_collection.my_test:
    name: fail me
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

from ansible.module_utils.basic import AnsibleModule


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        path=dict(type='str',required=True),
        name=dict(type='str', required=False, default='example'),
        content=dict(type='str',required=True),
        force=dict(type='bool', required=False, default=False)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        original_message='',
        message=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.params['path'][:-1] == '/':
        generated_path = module.params['path'] + module.params['name']
    else:
        generated_path = module.params['path'] + '/' + module.params['name']
    need_create = os.access(generated_path, os.F_OK) and not module.params['force']
    if module.check_mode or need_create:
        module.exit_json(**result)
    os.makedirs(module.params['path'],exist_ok=True)
    with open(generated_path, 'wb') as new:
        new.write(to_bytes(module.params['content']))
    result['original_message'] = 'Succeful created'
    result['message'] = 'goodbye'
    result['changed'] = True
    # if module.check_mode:
    #     module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    result['original_message'] = module.params['name']
    result['message'] = 'goodbye'

    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target
    if module.params['name']:
        result['changed'] = True

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    if module.params['name'] == 'fail me':
        module.fail_json(msg='You requested this to fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
```
2. Проверьте module на исполняемость локально `python -m ansible.modules.my_own_module payload.json`.

```json
{
  "ANSIBLE_MODULE_ARGS": {
      "name": "NewName",
      "path": "/tmp/new/",
      "content": "New file text for test",
      "force": false
      }
 }
 ```

3. Напишите single task playbook и используйте module в нём.
```yml
---
- name: test the new module
  gather_facts: false
  hosts: localhost
  tasks:
  - name: run the module
    my_own_module:
      name: NewName
      path: /tmp/new/
      content: New file text for test
      force: false
    register: testout
  - name: dump test output
    debug:
        msg: '({ testout})'
```

7. 
```bash
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features
under development. This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'
[WARNING]: ansible.utils.display.initialize_locale has not been called, this may result in incorrectly calculated text widths that can cause Display to print incorrect line
lengths

PLAY [test the new module] **************************************************************************************************************************************************

TASK [run the module] *******************************************************************************************************************************************************
ok: [localhost]

TASK [dump test output] *****************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "({ testout})"
}

PLAY RECAP ******************************************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

(venv) [node1] (local) root@192.168.0.13 ~/ansible
```
8. `deactivate`.
9. `ansible-galaxy collection init my_own_namespace.my_own_collection`
10. `mv ansible/modules/my_own_module.py my_own_collection/my_own_module/plugins/modules/`
```yml
---
- name: rum my_oun_riole
  gather_facts: false
  hosts: localhost
  roles: 
    - my_own_role
```
13. https://github.com/ottvladimir/my_own_collection.
```bash
$ ansible-galaxy collection install my_own_namespace-my_own_collection-1.0.0.tar.gz 
Process install dependency map
Starting collection install process
Installing 'my_own_namespace.my_own_collection:1.0.0' to '/root/.ansible/collections/ansible_collections/my_own_namespace/my_own_collection'
$ ansible-playbook playbook.yaml 
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [test the new module] *****************************************************************************************************************************************************************************************

TASK [run the module] **********************************************************************************************************************************************************************************************
changed: [localhost]

TASK [dump test output] ********************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "({ testout})"
}

PLAY RECAP *********************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
playbook
```yaml
---
- name: test the new module
  gather_facts: false
  hosts: localhost
  tasks:
  - name: run the module
    my_own_namespace.my_own_collection.my_own_module:
      name: NewName
      path: /tmp/new/
      content: New file text for test
      force: false
    register: testout
  - name: dump test output
    debug:
        msg: '({ testout})'
```
