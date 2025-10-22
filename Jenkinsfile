#!/usr/bin/env groovy
library 'status-jenkins-lib@v1.8.15'

pipeline {
  agent {
    docker {
      label 'linuxcontainer'
      image 'harbor.status.im/infra/ci-build-containers:linux-base-1.0.0'
      args '--volume=/nix:/nix ' +
           '--volume=/etc/nix:/etc/nix '
    }
  }

  options {
    disableRestartFromStage()
    disableConcurrentBuilds()
    /* manage how many builds we keep */
    buildDiscarder(logRotator(
      numToKeepStr: '20',
      daysToKeepStr: '30',
    ))
  }

  triggers {
    /* Build whenever there's a push to the repo */
    githubPush()
  }

  environment {
    GIT_COMMITTER_NAME = 'status-im-auto'
    GIT_COMMITTER_EMAIL = 'auto@status.im'
  }

  stages {
    stage('Build') {
      steps { script {
        nix.develop('./generate_summary.sh && mdbook build', pure: true)
        jenkins.genBuildMetaJSON('book/build.json')
      } }
    }

    stage('Publish') {
      steps {
        sshagent(credentials: ['status-im-auto-ssh']) {
          script {
            nix.develop("""
              ghp-import \
                -b deploy-master \
                -p book
              """
            )
          }
        }
      }
    }
  }

  post {
    cleanup { cleanWs() }
  }
}
