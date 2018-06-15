#!/usr/bin/env groovy


openshift.withCluster() { // Use "default" cluster or fallback to OpenShift cluster detection


    echo "Hello from the project running Jenkins: ${openshift.project()}"

        //Print environment, for debug purposes
        stage('environment') {
            sh 'env > env.txt'
            for (String i : readFile('env.txt').split("\r?\n")) {
                println i
            }
        }

    String projectName = encodeName("${JOB_NAME}")
    echo "name=${projectName}"

    //Stages outside a node declaration runs on the jenkins host
    //GO to a node with ruby
    //    https://github.com/redhat-cop/containers-quickstarts/tree/master/jenkins-slaves/jenkins-slave-ruby
//    node('jenkins-slave-ruby') {
        stage('checkout') {
            checkout scm
            def url = sh(returnStdout: true, script: 'git config remote.origin.url').trim()
        }

        stage('Create test project') {
            recreateProject(projectName)

            openshift.withProject(projectName) {


                APPLICATION_NAME = projectName
                stage("Build Ruby Docker Image") {

                    def rubyApp = openshift.newApp("ruby~${env.WORKSPACE}#${env.BRANCH_NAME}", "--strategy=source")

                    echo "new-app created ${rubyApp.count()} objects named: ${rubyApp.names()}"

                    rubyApp.describe()

                    def build = rubyApp.narrow("bc").object()
                    build.logs("-f")


//
//
//                    dockerFile = """
//FROM ruby:latest
//
//RUN mkdir ${APPLICATION_NAME}
//
//WORKDIR ${APPLICATION_NAME}
//
//COPY Gemfile Gemfile.lock ${APPLICATION_NAME}/
//
//RUN cd ${APPLICATION_NAME} && \
//    source /opt/rh/rh-ruby24/enable \
//    && bundle install
//
//COPY . ${APPLICATION_NAME}
//
//RUN chgrp -R 0 ${APPLICATION_NAME} && \\
//            chmod -R g=u /{APPLICATION_NAME}
//
//EXPOSE 3000
//CMD bundle exec rails s -p 3000 -b '0.0.0.0'
//"""
//
//                    buildConfig = openshift.newBuild("--dockerfile=\"${dockerFile}\"", "--name=${APPLICATION_NAME}-web").narrow("bc")
//                    build = buildConfig.startBuild("--from-dir=.")
//                    build.logs("-f")
                }

            }

        }
    }


private void recreateProject(String projectName) {
    echo "Delete the project ${projectName}, ignore errors if the project does not exist"
    try {
        openshift.selector("project/${projectName}").delete()
    } catch (e) {

    }

    openshift.selector("project/${projectName}").watch {
        echo "Waiting for the project ${projectName} to be deleted"
        return it.count() == 0
    }
//
//    //Wait for the project to be gone
//    sh "until ! oc get project ${projectName}; do date;sleep 2; done; exit 0"

    echo "Create the project ${projectName}"
    openshift.newProject(projectName)
}

/**
 * Encode the jobname as a valid openshift project name
 * @param jobName the name of the job
 * @return the jobname as a valid openshift project name
 */
private static String encodeName(groovy.lang.GString jobName) {
    def name = jobName
            .replaceAll("\\s", "-")
            .replaceAll("_", "-")
            .replaceFirst("^[^/]+/", '')
            .replace("/", '-')
            .replaceAll("^openshift-", "")
            .toLowerCase()
    return name
}
