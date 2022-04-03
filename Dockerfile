FROM ubuntu:14.04
ARG DEBIAN_FRONTEND=noninteractive
COPY source.list /etc/apt/sources.list
RUN apt-get update 
RUN apt-get install -y dialog apt-utils openssh-server  xfce4 xfce4-goodies tightvncserver
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ADD ./ /hit-oslab/
RUN cd /hit-oslab/ && sh setup.sh
#RUN export USER=root
ENV USER root
RUN mkdir -p "$HOME/.vnc" && chmod go-rwx "$HOME/.vnc" ; \
    /bin/bash -c "echo -e 'password\npassword\nn' | vncpasswd"; echo; \
    echo "#!/bin/bash" >  ~/.vnc/xstartup; \
    echo "unset SESSION_MANAGER" >>  ~/.vnc/xstartup; \
    echo "unset DBUS_SESSION_BUS_ADDRESS" >>  ~/.vnc/xstartup; \
    echo "startxfce4 &" >>  ~/.vnc/xstartup; \
    echo "[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup" >>  ~/.vnc/xstartup; \
    echo "[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources" >>  ~/.vnc/xstartup; \
    echo "xsetroot -solid grey"  >>  ~/.vnc/xstartup; \
    echo "vncconfig -iconic &    " >>  ~/.vnc/xstartup; \
    sudo chmod +x ~/.vnc/xstartup; \
    touch ~/.Xauthority ;

EXPOSE 5901
WORKDIR /hit-oslab

ENTRYPOINT export USER=root; vncserver :1 && /bin/bash
