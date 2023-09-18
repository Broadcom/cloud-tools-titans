### instruction on how to get fips version of envoy
### gcr.io/istio-enterprise/proxyv2:1.10.2-fips
FROM sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/icds-infra-docker-rh-ubi-minimal-with-tools:1.0.31
USER root
RUN microdnf repolist
ENV MICRODNF_ARGS=--disableplugin=subscription-manager\ --disablerepo=*\ --enablerepo=ubi-8-appstream-rpms\ --enablerepo=ubi-8-baseos-rpms
RUN microdnf install ca-certificates -y ${MICRODNF_ARGS}
RUN microdnf install -y jq

USER default