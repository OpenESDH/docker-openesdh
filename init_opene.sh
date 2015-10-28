bower update --allow-root | xargs echo

cat > /etc/supervisor/conf.d/openeui.conf << EOF
[program:openeui]
priority=20
directory=/OpeneUI
command=gulp local
user=root
autostart=true
autorestart=true
EOF