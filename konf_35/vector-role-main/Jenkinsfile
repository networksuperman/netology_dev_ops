pipeline {
    agent {
     label 'ansible'
    }
    stages {
        stage('Download repository from GitHub') {
            steps {
                dir('vector-role') {
                    git branch: 'main', credentialsId: 'github', url: 'git@github.com:P0zitiff4ik/vector-role.git'
                }
            }
        }
        stage ('Molecule test') {
            steps {
                sh 'molecule test'
            }
        }
    }
}
