pipeline {
    environment {

        // If you don't have your own docker registry, you can bring one up
        // by cd'ing to ci-infratructure and running "docker-compose up -d"
        DOCKER_REGISTRY='10.40.100.51:5000/schahal/spring-petclinic'

        // ^ or you can bring up JFrog's Artifactory and set one up; but for this
        //   pupose, the dockerhub container is finee
    }

    agent { label 'master' }

    stages {

        stage('build') {
            agent { 
                docker { 
                    label 'linux-agent-with-docker'
                    image 'maven:3.6.3' 
                }
            }

            steps {
                // The unset is needed due to https://issues.jenkins-ci.org/browse/JENKINS-47890
                sh 'unset MAVEN_CONFIG && ./mvnw -B -DskipTests clean package'
            }
        }

        stage('test') {
            agent { 
                docker { 
                    label 'linux-agent-with-docker'
                    image 'maven:3.6.3' 
                }
            }

            steps {
                // The unset is needed due to https://issues.jenkins-ci.org/browse/JENKINS-47890
                sh 'unset MAVEN_CONFIG && ./mvnw test'
            }

            /**
             *  Can add a "post" step here (which will upload the test results 
             *  to jenkins), but this will force me to add the junit jenkins 
             *  plugin at ci-infrastructure/plugins.txt and re-compose up 
             *  jenkins, so will skip this for now ;)
             **/
        }
        
        stage('release') {
            agent {
                label 'linux-agent-with-docker'
            }

            steps {
                sh """
                   docker build -t ${DOCKER_REGISTRY}:${env.GIT_COMMIT} .
                   docker push ${DOCKER_REGISTRY}:${env.GIT_COMMIT}
                """
            }
        }
    }
}
