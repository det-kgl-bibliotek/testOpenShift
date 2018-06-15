#!/usr/bin/env groovy


openshift.withCluster() { // Use "default" cluster or fallback to OpenShift cluster detection


    echo "Hello from the project running Jenkins: ${openshift.project()}"

//        //Print environment, for debug purposes
//        stage('environment') {
//            sh 'env > env.txt'
//            for (String i : readFile('env.txt').split("\r?\n")) {
//                println i
//            }
//        }

    String projectName = encodeName("${JOB_NAME}")
    echo "name=${projectName}"

    //Stages outside a node declaration runs on the jenkins host
    //GO to a node with ruby
    //    https://github.com/redhat-cop/containers-quickstarts/tree/master/jenkins-slaves/jenkins-slave-ruby
    node('jenkins-slave-ruby') {
        stage('checkout') {
            checkout scm
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
    return name
}
