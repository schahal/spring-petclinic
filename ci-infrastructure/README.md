# Build-a-Pipeline Overview

Files added and/or modified:
```
.
├── Dockerfile
├── Jenkinsfile
├── ci-infrastructure
│   ├── Dockerfile
│   ├── README.md
│   ├── config.yml
│   ├── docker-compose.yml
│   ├── env.sh
│   ├── log.properties
│   └── plugins.txt
├── pom.xml
├── screenshots/

```

## Prerequisites

If you already have your own Jenkins server and docker registry, ignore this section.

Otherwise, `cd` to the `ci-infrastructure/` directory to bring up docker instances of a Docker Registry and a Jenkins Server (the Jenkins server's configuration is via Jenkins-configuration-as-Code in this dir) by running:

    . env.sh && docker-compose up -d

To have Jenkins store/configure these on bringup, you can/should edit::
* `env.sh` -  to include your Git repo and SSH credentials (for any additional external slaves)
* `config.yml` - change the `.nodes` sections to add any external machines/slaves you potentially want to run on 

Once run, your Jenkins and Docker registry should be up at http://localhost:8080 and http://localhost:5000, repsectively.

## Description of Work

* `Dockerfile` - the multi-stage docker build (second stage takes the jar and places it into a smaller base image)
    * Useful for devs to build/run locally

          docker build -t somename:sometag .
          docker run -it -d -p 8080:8080 somename:sometag
          
    * Used in `release` stage of the Jenkins job
* `Jenkinsfile` - Outlines the "build", "test", and "release" stages of CI
    * The "release" stage will push the image to your docker registry upon success (tagged with commit sha)
* `ci-infrastructure/` - The most time-consuming part; to create repeatable infrastructure to use for CI (see "Prequisites" section)
    * `Dockerfile` - Extends base jenkins image to allow for custom default plugins, configuration-as-code (JcasC), and logging
    * `config.yml` - the JcasC definition
        * `.nodes`: defines dditional slaves you want to help with CI
        * `.credentials`: SSH and Git creds to access repos/slaves get placed as managed creds
        * `.jobs`: Creates the Pipeline job definition to source off `Jenkinsfile`
    * `docker-compose.yml` - See "Prerequisites" section on its usage
    * `env.sh` - See "Prerequisites" section on its usage
    * `log.properties` - so Jenkins server can log console output
    * `plugins.txt` - the default plugins list that get installed onto Jenkins which we need for our pipeline
* `pom.xml` - changes to resolve artifact thru Jcenter


## Quick notes and Gotchas
1. The infrastructure bringup as code took longer than the actual pipeline (Jenkinsfile)
2. This was worth it, as it is repeatable/quick to bring up a fully provisioned Jenkins now
3. We can add additional triggers to the config.yml -> jobs and push notifications as further enhancements (skipped due to no time)
4. Artifactory can be used as a docker registry in this case (skipped due to time, the image from Docker sufficed) 
5. Since the registry we have doesnt have certs enabled, any clients (e.g., the Jenkins slave) should make sure its `/etc/docker/daemon.json` has:

    {
      "insecure-registries" : ["<IP>:<PORT>"]
    }


## Screenshots of Pipeline

#### Triggered

![Pipeline Triggered](https://github.com/schahal/spring-petclinic/raw/main/screenshots/pipeline_build_triggering.png)

#### Build Passing

![Pipeline Build Passing](https://github.com/schahal/spring-petclinic/raw/main/screenshots/pipeline_build_stage_passing.png)

#### Test Passing

![Pipeline Test Passing](https://github.com/schahal/spring-petclinic/raw/main/screenshots/pipeline_test_stage_passing.png)

#### Resolving via JCenter

![Pipeline via JCenter](https://github.com/schahal/spring-petclinic/raw/main/screenshots/pipeline_jcenter_resolving.png)

#### Image Created and Pushed

![Pipeline Image Pushed](https://github.com/schahal/spring-petclinic/raw/main/screenshots/pipeline_image_packaged_and_pushed.png)
