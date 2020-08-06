FROM jenkins/jenkins:lts

# The three files we're copying are:
#
#   1) plugins.txt:    The jenkins plugins to install by default
#   2) config.yml:     The jenkins-config-as-code file (referenced via environment
#                      when jenkins is brought up
#   3) log.properties: Referenced via environment when jenkins is brought up
#                      in order for jobs to log properly
COPY plugins.txt config.yml log.properties /usr/share/jenkins/ref/

# Installs the plugins
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
