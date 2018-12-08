import os
import argparse
from gitlab import Gitlab

boot_title = 'boot'


def get_pub_key():
    pub_key_file = os.path.join(os.getenv("HOME"), '.ssh', 'id_rsa.pub')
    with open(pub_key_file) as fp:
        pub_key = fp.read(40960)
    return pub_key


def clean_key(url, token):
    gitlab = Gitlab(url, token, ssl_verify=False)
    gitlab.auth()
    keys = gitlab.user.keys.list()
    for key in keys:
        if boot_title == key.title:
            key.delete()
            break


def create_key(url, token, pub_key):
    gitlab = Gitlab(url, token, ssl_verify=False)
    gitlab.auth()
    gitlab.user.keys.create({'title': boot_title,
                             'key': pub_key})


def upload_key(url, token):
    pub_key = get_pub_key()
    if pub_key:
        clean_key(url, token)
        create_key(url, token, pub_key)
    else:
        print "ssh pubkey is not exist"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--token", help="gitlab access token")
    parser.add_argument("-l", "--url", help="gitlab url")
    args = parser.parse_args()
    upload_key(args.url, args.token)


if __name__ == "__main__":
    main()
