dnf install git docker zsh gcc kernel-headers-$(uname -r) tmux screen

systemctl enable sshd
systemctl start sshd
systemctl enable docker
systemctl start docker

chgrp wheel /var/run/docker.sock
