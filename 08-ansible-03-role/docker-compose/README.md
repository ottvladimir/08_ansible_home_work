docker-compose up -d && \
echo "$(docker inspect -f '{{ range.NetworkSettings.Networks }}{{ .IPAddress }}{{end}}' elasticsearch)   elastic">>/etc/hosts && \
echo "$(docker inspect -f '{{ range.NetworkSettings.Networks }}{{ .IPAddress }}{{end}}' kibana)   kibana">>/etc/hosts &&\
ssh-copy-id root@elastic 
ssh-copy-id root@kibana

