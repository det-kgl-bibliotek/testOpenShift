#!/usr/bin/env groovy


openshift.withCluster() { // Use "default" cluster or fallback to OpenShift cluster detection


    echo "Hello from the project running Jenkins: ${openshift.project()}"

    //Create template with maven settings.xml, so we have credentials for nexus
    podTemplate(
            cloud: 'openshift', //cloud must be openshift
            label: 'ruby-on-rails',
            name: 'ruby-on-rails',
            containers: [
                    containerTemplate(name:'Ruby',image:'ruby:2.2.2')
            ]
    ) {

        //Stages outside a node declaration runs on the jenkins host

//        //Print environment, for debug purposes
//        stage('environment') {
//            sh 'env > env.txt'
//            for (String i : readFile('env.txt').split("\r?\n")) {
//                println i
//            }
//        }

        String projectName = encodeName("${JOB_NAME}")
        echo "name=${projectName}"

        //GO to a node with maven and settings.xml
        node('ruby-on-rails') {


        }
    }
}