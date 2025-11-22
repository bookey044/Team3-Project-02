#! /bin/bash

setenforce 0

dnf install -y firewalld openssh-server
systemctl enable --now firewalld sshd

# SSH/SFTP (22/tcp) 포트를 OS 방화벽에서 영구적으로 허용
firewall-cmd --permanent --add-service=ssh
firewall-cmd --reload

# --- SFTP 전용 사용자 설정
SFTP_USER="team3"
SFTP_PASS="It12345!"

# 1. 'team3' 생성: 셸 접속(bash 등)은 불가능하도록 설정하여 보안 강화
useradd -m -s /sbin/nologin ${SFTP_USER}
echo "${SFTP_USER}:${SFTP_PASS}" | chpasswd

# 2. SFTP 전용 디렉토리 설정 (Chroot Jail의 기본 규칙)
# 홈 디렉토리(/home/team3)는 root가 소유해야 합니다.
chown root:root /home/${SFTP_USER}
chmod 755 /home/${SFTP_USER}

# 3. 파일 업로드 디렉토리 생성 및 권한 부여
# 이 디렉토리에만 'team3' 계정이 쓰기 권한을 가집니다.
mkdir /home/${SFTP_USER}/upload
chown ${SFTP_USER}:${SFTP_USER} /home/${SFTP_USER}/upload
chmod 750 /home/${SFTP_USER}/upload

# --- SFTP Chroot Jail 활성화 (핵심 보안 설정) ---
# 4. sshd_config 파일에 SFTP 설정 추가
cat << EOF >> /etc/ssh/sshd_config

# SFTP-only configuration for team3
Match User ${SFTP_USER}
    ChrootDirectory /home/${SFTP_USER}
    ForceCommand internal-sftp
    AllowTcpForwarding no
    X11Forwarding no
EOF

# 5. SSH 서비스 재시작하여 설정 적용
systemctl restart sshd