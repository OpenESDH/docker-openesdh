npm install
bower update --allow-root | xargs echo
gulp all-modules-install

cat > /etc/supervisor/conf.d/openeui.conf << EOF
[program:openeui]
priority=20
directory=/OpeneUI
command=gulp all-modules local
user=root
autostart=true
autorestart=true
EOF