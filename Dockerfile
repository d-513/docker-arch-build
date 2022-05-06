FROM archlinux:base-devel
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm cron git ccache
WORKDIR /internal
COPY entry /internal/entry
COPY builder /internal/builder
COPY tasks/ /internal/tasks/
RUN useradd -m archbuild
COPY sudoers /etc/sudoers.d/archbuild
COPY cron /etc/cron.d/archbuild
RUN chmod 644 /etc/cron.d/archbuild
RUN chmod +x /internal/entry /internal/builder
ENTRYPOINT [ "/internal/entry" ]
