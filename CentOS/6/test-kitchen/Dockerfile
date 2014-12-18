FROM centos:centos6
#
MAINTAINER NAKAJIMA, Ryuichi (a.k.a. libero18)

# 環境変数
ENV PATH $PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# パッケージアップデート＆インストール
RUN yum -y update ;\
    yum -y install --enablerepo=centosplus openssl-devel ;\
    yum -y install openssh openssh-server openssh-clients sudo libselinux-python curl
    yum -y clean all

# 初期設定
RUN sed -i 's/^/#/g' /etc/sysconfig/i18n ;\
    echo 'LANG="C"' >> /etc/sysconfig/i18n
RUN cp /usr/share/zoneinfo/Japan /etc/localtime ;\
    sed -i 's/^/#/g' /etc/sysconfig/clock ;\
    echo -e 'ZONE="Asia/Tokyo"\nUTC=false\nARC=false' >> /etc/sysconfig/clock

# セキュリティ設定
RUN sed -i "s/^#auth\t\trequired\tpam_wheel.so use_uid/auth\t\trequired\tpam_wheel.so use_uid/g" /etc/pam.d/su ;\
    echo -e "## Read drop-in files from /etc/sudoers.d (the # here does not mean a comment)\n#includedir /etc/sudoers.d\n\nDefaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin\n" >> /etc/sudoers ;\
    sed -i "s/^Defaults    requiretty$/Defaults:%provisioner    \!requiretty/g" /etc/sudoers ;\
    test -d /etc/sudoers.d || mkdir /etc/sudoers.d ;\
    chmod 755 /etc/sudoers.d ;\
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/wheel ;\
    chmod 440 /etc/sudoers.d/wheel

# ユーザ作成
RUN useradd -G wheel -m provisioner ;\
    sudo -u provisioner mkdir /home/provisioner/.ssh ;\
    chmod 700 /home/provisioner/.ssh ;\
    sudo -u provisioner curl https://github.com/libero18.keys -o /home/provisioner/.ssh/authorized_keys ;\
    chmod 600 /home/provisioner/.ssh/authorized_keys

# ポート開放
EXPOSE 22

