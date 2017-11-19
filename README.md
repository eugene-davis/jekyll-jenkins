# jekyll-jenkins
Docker image build from Jenkins Apline image with Jekyll loaded in. Derived from https://github.com/jenkinsci/docker.
Allows you to develop a Jenkinsfile for your Jekyll site, and have it build in Jenkins.

# Usage
Start a container with `docker run -p 8080:8080 -p 5000:5000 jekyll-jenkins`. 
A volume will be automatically created for `/var/jenkins_home` to make configuration persist.

The Jenkins instance will start up with Security disabled. You can enable and configure this through the UI.
You can then add pipeline (or other projects) via the UI. Basic ruby and build tools are included, so you can install plugins as needed - I recommend you include the install in the pipeline description.

# Example Jenkinsfile Definition
```
pipeline {
    agent any

    stages {
        stage('Load Plugins') {
            steps {
                sh "gem install octopress-minify-html"
            }
        }
        stage('Build') {
            steps {
                script {
                    if (env.BRANCH_NAME.equals("master")) {
                        sh "jekyll build --incremental"
                    } else {
                        sh "jekyll build --incremental --drafts"
                    }
                }
            }
        }
    }

    post {
        success {
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '_site', reportFiles: 'index.html', reportName: 'industrialdragonfly.com', reportTitles: ''])
            sh "mv _site industrialdragonfly.com"
            archiveArtifacts artifacts: 'jekyll-jenkins.com/', fingerprint: true, onlyIfSuccessful: true
            }
    }
}
```
