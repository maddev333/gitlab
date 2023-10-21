# Github operator running on Kubernetes
Run gitlab_operator.sh
Run mygitlab.yml

# Github runner running on Docker
sudo docker pull gitlab/gitlab-runner:latest
sudo docker volume create gitlab-runner-config
sudo docker run -d --name gitlab-runner --restart always -v /var/run/docker.sock:/var/run/docker.sock -v gitlab-runner-config:/etc/gitlab-runner gitlab/gitlab-runner:latest


# Github runner register with Docker executor
(self-signed cert) openssl s_client -showcerts -connect gitlab.example.com:443 -servername gitlab.example.com < /dev/null 2>/dev/null | openssl x509 -outform PEM > gitlab.example.com.crt
sudo docker cp gitlab.example.com.crt gitlab-runner:/etc/gitlab-runner/certs/ca.crt

docker run --rm -it -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register --tls-ca-file=gitlab.example.com.crt

```
Enter an executor: custom, docker-windows, ssh, virtualbox, docker+machine, instance, docker, parallels, shell, docker-autoscaler, kubernetes: docker
Enter the default Docker image (for example, ruby:2.7): microsoft/dotnet-framework:4.7.2
```

(Restart after install) sudo docker restart gitlab-runner 


