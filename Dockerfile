FROM archlinux

RUN pacman --noconfirm -Sy base-devel aws-cli
RUN useradd build -m
RUN echo 'build ALL=NOPASSWD: ALL' >> /etc/sudoers
RUN echo '[menari]' >> /etc/pacman.conf
RUN echo 'Server = https://s3.amazonaws.com/arch.menari.io/repo/x86_64' >> /etc/pacman.conf
RUN echo 'SigLevel = Never' >> /etc/pacman.conf
RUN pacman --noconfirm -Syu

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
