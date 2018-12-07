import os
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization


def generate_RSA(bits=4096):
    new_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=bits,
        backend=default_backend()
    )
    private_key = new_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.TraditionalOpenSSL,
        encryption_algorithm=serialization.NoEncryption()
    ).decode()
    public_key = new_key.public_key().public_bytes(
        encoding=serialization.Encoding.OpenSSH,
        format=serialization.PublicFormat.OpenSSH
    ).decode()
    return private_key, public_key


def create_keypair():
    work_space = os.path.join(os.getenv("HOME"), '.ssh')
    if os.path.isdir(work_space):
        os.chmod(work_space, 0700)
    else:
        os.mkdir(work_space, 0700)
    private_key, public_key = generate_RSA()
    private_file = os.path.join(work_space, 'id_rsa')
    public_file = os.path.join(work_space, 'id_rsa.pub')
    with open(private_file, 'w') as fp:
        fp.write(private_key)
    with open(public_file, 'w') as fp:
        fp.write(public_key)
    os.chmod(private_file, 0600)
    os.chmod(public_file, 0600)


def main():
    create_keypair()


if __name__ == '__main__':
    main()
