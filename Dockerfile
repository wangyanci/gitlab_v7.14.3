from ubuntu:14.04
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y vim
RUN apt-get install -y git
RUN apt-get install -y ssh
RUN curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
RUN apt-get install -y gitlab-ce=7.14.3-ce.0
RUN sed -i 's/^ulimit -i 62793/#ulimit -i 62793/g' /opt/gitlab/embedded/bin/runsvdir-start
RUN sed -i 's/^echo "1000000" > \/proc\/sys\/fs\/file-max/#echo "1000000" > \/proc\/sys\/fs\/file-max/g' /opt/gitlab/embedded/bin/runsvdir-start
RUN sed -i "s/^external_url.*/external_url 'http:\/\/114.115.169.130:7076'/g" /etc/gitlab/gitlab.rb
RUN sed -i "s/.*gitlab_shell_ssh_port.*/gitlab_rails['gitlab_shell_ssh_port'] = 2222/g" /etc/gitlab/gitlab.rb
COPY ./runmaster /opt/gitlab/embedded/bin/
RUN chmod 766 /opt/gitlab/embedded/bin/runmaster
CMD ["bash", "-c", "/etc/init.d/ssh start && /opt/gitlab/embedded/bin/runmaster && gitlab-ctl reconfigure && tailf /var/log/gitlab/gitlab-rails/application.log"]
