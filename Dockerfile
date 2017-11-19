FROM jenkins/jenkins:lts

# Install Jenkins plugins
COPY jenkins-plugins.txt /usr/share/jenkins/ref/jenkins-plugins.txt
COPY jekyll-plugins.txt /usr/share/jenkins/ref/jekyll-plugins.txt

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/jenkins-plugins.txt

# Mark Jenkins as configured
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false -Djenkins.CLI.disabled=true

# Install Jekyll
USER root
RUN apt-get update && apt-get install -y ruby-full build-essential && gem update --system && gem install jekyll
# Ruby Gems location
RUN chown -R root:jenkins /var/lib/gems && chmod 770 -R /var/lib/gems/
USER jenkins

VOLUME ["/var/jenkins_home"]