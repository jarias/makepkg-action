FROM archlinux

RUN pacman --noconfirm -Sy base-devel
RUN useradd build -m
RUN echo 'build ALL=NOPASSWD: ALL' >> /etc/sudoers

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
