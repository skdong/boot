from gitlab import Gitlab
import argparse



class GitlabProxy(object):
    def __init__(self, url, token):
        self._gitlab = Gitlab(url,
                              ssl_verify=False,
                              private_token=token)
        self._gitlab.auth()

    def get_groups(self):
        return self._gitlab.groups.list()

    # create group
    def create_group(self, group_name):
        self._gitlab.groups.create({'name': group_name,
                                    'path': group_name})

    def get_projects(self, group_id):
        return self._gitlab.projects.list(group_id=group_id)

    # creat projects
    def create_project(self, name, group_id):
        self._gitlab.projects.create({'name': name,
                                      'namespace_id': group_id})

    # add user ssh key
    def upload_ssh_key(self, title, key):
        return self._gitlab.user.keys.create({'title': title, 'key': key})

    def get_ssh_keys(self):
        return self._gitlab.user.keys.list()

    def delete_ssh_key(self, id):
        return self._gitlab.user.keys.delete(id)


class CodesManager(object):
    def __init__(self, url, token):
        self.git_proxy = GitlabProxy(url, token)

    def get_group(self, name):
        groups = self.git_proxy.get_groups()
        for group in groups:
            if group.name == name:
                return group
        return None

    def get_or_create_group(self, name):
        group = self.get_group(name)
        if group:
            return group
        else:
            self.git_proxy.create_group(name)
        return self.get_group(name)

    def get_group_projects(self, group_name):
        group = self.get_group(group_name)
        return group.projects.list()

    def get_project(self, name, group_name):
        projects = self.get_group_projects(group_name)
        for project in projects:
            if project.name == name:
                return project
        return None

    def create_project(self, name, group_name):
        group_id = self.get_group(group_name).id
        self.git_proxy.create_project(name, group_id)

    def get_or_create_project(self, name, group_name):
        project = self.get_project(name, group_name)
        if project:
            return project
        self.create_project(name, group_name)
        return self.get_project(name, group_name)

    def get_ssh_key(self, title):
        keys = self.git_proxy.get_ssh_keys()
        for key in keys:
            if key.title == title:
                return key
        return None

    def get_or_create_sshkey(self, title, key):
        ssh_key = self.get_ssh_key(title)
        if ssh_key:
            return ssh_key
        self.git_proxy.upload_ssh_key(title, key)
        return self.get_ssh_key(title)

    def delete_ssh_key(self, title):
        key = self.get_ssh_key(title)
        self.git_proxy.delete_ssh_key(key.id)


def init_dire(url, token, group):
    manager = CodesManager(url, token)
    manager.get_or_create_group(group)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--token", help="gitlab access token")
    parser.add_argument("-l", "--url", help="gitlab url")
    parser.add_argument("-g", "--group", help="dire group")
    args = parser.parse_args()
    init_dire(args.url, args.token, args.group)

if __name__ == '__main__':
    main()
