#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_own_module

short_description: This is a module for creating a text file

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is a module for creating and filling a text file with content.

options:
    path:
        description: Path to file
        required: true
        type: str
    content:
        description: File contents
        required: false
        type: str

extends_documentation_fragment:
    - my_own_namespace.yandex_cloud_elk.my_doc_fragment_name

author:
    - Igor Panarin (@networksuperman)
'''

EXAMPLES = r'''
- name: Test for creating a file
  my_own_namespace.yandex_cloud_elk.my_own_module:
    path: "/tmp/test_file.txt"

- name: Test for creating a file with content
  my_own_namespace.yandex_cloud_elk.my_own_module:
    path: "/tmp/test_file.txt"
    content: "test content"
'''

RETURN = r'''
'''

from ansible.module_utils.basic import AnsibleModule
from os import path
from os import makedirs

def run_module():
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=False)
    )

    result = dict(
        changed=False
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=False
    )

    if module.check_mode:
        module.exit_json(**result)

    if not path.exists(module.params['path']):
        makedirs(path.dirname(module.params['path']), exist_ok=True)
        with open(module.params['path'], 'w') as f:
            f.write(module.params['content'])
            result['changed'] = True
    elif open(module.params['path'], 'r').read() != module.params['content']:
        with open(module.params['path'], 'w') as f:
            f.write(module.params['content'])
            result['changed'] = True

    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
