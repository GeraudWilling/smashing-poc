#!/bin/sh

#puma config.ru

apiVersion: template.openshift.io/v1
kind: Template
labels:
  template: application # The label applicated to all template objects
message: |- #Message displayed after a successfully processing of the template
  A Jenkins server will be automatically instantiated in this project to manage
  the Pipeline BuildConfig created by this template.  You will be able to log in to
  it using your OpenShift user credentials.


# The metadata of the templates.
metadata:
  annotations:
    description: |- 
      The template contains a Jenkinsfile - a definition of a multi-stage CI/CD process - 
      that leverages the underlying OpenShift platform for dynamic and scalable builds.
    iconClass: icon-jenkins
    tags: instant-app,jenkins,ruby
  name: smashing-template #The name of the template
  resourceVersion: "1.0.0"


# The list of parameters of the pipeline.
parameters:
- description: The name assigned to all of the objects defined in this template.
  displayName: Name
  name: NAME
  required: true
  value: smashing
- description: The exposed hostname that will route to the Node.js service, if left blank a value will be defaulted.
  displayName: Application Hostname
  name: APPLICATION_DOMAIN
- description: The URL of the repository with your application source code.
  displayName: Git Repository URL
  name: SOURCE_REPOSITORY_URL
  required: true
  value: https://github.com/GeraudWilling/smashing-poc.git
- description: Set this to a branch name, tag or other ref of your repository if you are not using the default branch.
  displayName: Git Reference
  value: develop
  name: SOURCE_REPOSITORY_REF
- description: Set this to the relative path to your project if it is not in the root of your repository.
  displayName: Context Directory
  name: CONTEXT_DIR

# The list of openshift objects to create within the templates (BuildConfig, Deployment, Service, Route)
objects:
- apiVersion: v1
  kind: BuildConfig
  metadata:
    #annotations:
    #  pipeline.alpha.openshift.io/uses: '[{"name": "${NAME}", "namespace": "", "kind": "DeploymentConfig"}]'
    labels:
      name: ${NAME}
    name: ${NAME}
  spec:
    source:
      git:
        ref: ${SOURCE_REPOSITORY_REF}
        uri: ${SOURCE_REPOSITORY_URL}
      type: Git
    strategy:
      jenkinsPipelineStrategy:
        jenkinsfilePath: jenkinsfile
      type: JenkinsPipeline
- apiVersion: v1
  kind: Service
  metadata:
    annotations:
    name: ${NAME}
  spec:
    ports:
    - name: web
      port: 8080
      targetPort: 8080
    selector:
      name: ${NAME}
- apiVersion: v1
  kind: Route
  metadata:
    name: ${NAME}
  spec:
    host: ${APPLICATION_DOMAIN}
    to:
      kind: Service
      name: ${NAME}
