FROM jenkins/jenkins:lts

# Install Jenkins plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Mark Jenkins as configured
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false -Djenkins.CLI.disabled=true

# Install Jekyll
USER root
RUN apt-get update && apt-get install -y ruby-full build-essential && gem install jekyll && gem install octopress-minify-html
USER jenkins

# Persist Jenkins
VOLUME ["/var/jenkins_home"]