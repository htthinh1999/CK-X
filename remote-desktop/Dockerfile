# Base Image
FROM nishanb/ck-x-simulator-vnc-base:v3

# Switch to root user for installations
USER 0

# Update and install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    ssh-client \
    telnet \
    nano \
    vim \
    curl \
    wget \
    xclip

#create candidate user
RUN useradd -m candidate

#set hostname as terminal
RUN echo "export HOSTNAME=terminal" >> /headless/.bashrc
#set terminal to bash
RUN echo "export TERM=xterm" >> /headless/.bashrc

#when shell open switch to candidate user
RUN echo "cd /home/candidate && su candidate" >> /headless/.bashrc

#disable asking for ssh host verification
RUN mkdir -p /home/candidate/.ssh
RUN touch /home/candidate/.ssh/config
RUN echo "StrictHostKeyChecking no" >> /home/candidate/.ssh/config
RUN echo "UserKnownHostsFile /dev/null" >> /home/candidate/.ssh/config

# VSCodium
# 1.71.2 is the last release that still runs on this Xenial based image,
# later builds require libnss3 >= 3.30 and GTK >= 3.20.
ENV VSCODIUM_VERSION=1.71.2.22258

RUN apt-get update && apt-get install -y \
    libnss3 \
    libnspr4 \
    libgbm1 \
    libdrm2 \
    libasound2 \
    libatspi2.0-0 \
    libxkbcommon0 \
    libxkbfile1 \
    libsecret-1-0 \
    libxss1 \
    xdg-utils \
 && mkdir -p /opt/vscodium \
 && curl -fsSL -o /tmp/vscodium.tar.gz "https://github.com/VSCodium/vscodium/releases/download/${VSCODIUM_VERSION}/VSCodium-linux-x64-${VSCODIUM_VERSION}.tar.gz" \
 && tar -xzf /tmp/vscodium.tar.gz -C /opt/vscodium \
 && rm /tmp/vscodium.tar.gz \
 && cp /opt/vscodium/resources/app/resources/linux/code.png /usr/share/pixmaps/vscodium.png

#launcher wrapper, application entry and desktop shortcut
COPY config/codium-wrapper.sh /usr/local/bin/codium
COPY config/vscodium.desktop /usr/share/applications/vscodium.desktop
COPY config/vscodium.desktop /headless/Desktop/VSCodium.desktop
RUN chmod +x /usr/local/bin/codium /headless/Desktop/VSCodium.desktop \
 && ln -s /usr/local/bin/codium /usr/local/bin/code

#default VSCodium settings for the desktop session user and for candidate
COPY config/vscodium-settings.json /headless/.vscodium-data/User/settings.json
COPY config/vscodium-settings.json /home/candidate/.vscodium-data/User/settings.json
RUN chown -R candidate:candidate /home/candidate/.vscodium-data

#panel docked to the top of the screen, with window buttons (task switcher),
#plus a dock at the bottom
COPY config/xfce4-panel.xml /headless/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
COPY config/launcher-8/thunar.desktop /headless/.config/xfce4/panel/launcher-8/thunar.desktop
COPY config/launcher-9/terminal.desktop /headless/.config/xfce4/panel/launcher-9/terminal.desktop
COPY config/launcher-10/firefox.desktop /headless/.config/xfce4/panel/launcher-10/firefox.desktop
COPY config/launcher-11/vscodium.desktop /headless/.config/xfce4/panel/launcher-11/vscodium.desktop

# Copy startup script
COPY startup.sh /usr/local/bin/startup.sh
# Strip Windows CRLF line endings (checkouts on Windows) so the scripts run in Linux
RUN sed -i 's/\r$//' /usr/local/bin/startup.sh /usr/local/bin/codium 2>/dev/null; chmod +x /usr/local/bin/startup.sh

COPY agent.py /tmp/agent.py

RUN sed -i '/### every exit != 0 fails the script/a /usr/local/bin/startup.sh' /dockerstartup/vnc_startup.sh
