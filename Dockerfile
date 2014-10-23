FROM debian:jessie
MAINTAINER jb. poupon <faltad@sbrk.org>

# Distro
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

# Common packages
RUN apt-get install -q -y									\
    	    sudo										\
    	    wget										\
	    openssh-server									\
   	    emacs23-nox										\
	    auto-complete-el									\
	    git-core										\
    	    zsh											\
	    tmux										\
	    htop										\
	    python										\
	    python-virtualenv									\
	    pep8										\
	    python-sphinx									\
	    jekyll										\
	    php5										\
	    apache2
    && apt-get clean -q -y

# Setup ssh
RUN mkdir /var/run/sshd

# Setup user faltad
RUN yes | adduser --disabled-password faltad --shell /bin/zsh					\
    && mkdir -p /home/faltad/.ssh/									\
    && wget https://github.com/faltad.keys -O /home/faltad/.ssh/authorized_keys		\
    && chown -R faltad:faltad /home/faltad								\
    && chmod 700 /home/faltad/.ssh									\
    && chmod 600 /home/faltad/.ssh/authorized_keys							\
    && echo '%faltad   ALL= NOPASSWD: ALL' >> /etc/sudoers						\
    && sudo -u faltad sh -c 'cd /home/faltad ; wget http://install.ohmyz.sh -O - | sh || true'


# Confs and files
ADD confs/motd /etc/motd
ADD confs/emacs /home/faltad/.emacs
ADD confs/gitconfig /home/faltad/.gitconfig
ADD confs/zsh /home/faltad/.zshrc

RUN mkdir /home/faltad/.emacs.d										\
    && wget https://raw.githubusercontent.com/ejmr/php-mode/master/php-mode.el -O /home/faltad/.emacs.d/php-mode.el	\
    && wget https://raw.githubusercontent.com/fxbois/web-mode/master/web-mode.el -O /home/faltad/.emacs.d/web-mode.el

RUN chown faltad:faltad /home/faltad/.emacs /home/faltad/.gitconfig /home/faltad/.zshrc

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
