FROM centos:7.4.1708
MAINTAINER "Giorgio Carlo Gili Tos" <giorgio.gilitos@gmail.com>

# Update packages and install base packages
# Always clean yum cache at the end, in order to save space in the docker image
RUN yum -y update && \
  yum -y install yum-plugin-ov tar zip unzip bsdtar iproute net-tools wget sysvinit-tools vim && \
  yum clean all

ENV JAVA_VERSION=8 \
    JAVA_UPDATE=151 \
    JAVA_BUILD=12 \
    JAVA_PATH=e758a0de34e24606bca991d704f6dcbf \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

# install JDK
RUN mkdir -p /opt/jdk; cd /opt/jdk; \
  curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_PATH}/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" | tar zx; \
  ln -s jdk1.8.0_${JAVA_UPDATE} current

ENV JAVA_HOME /opt/jdk/current
ENV PATH $PATH:$JAVA_HOME/bin

# patch the JDK with Unrestricted Jurisdiction Policy Files (needed for security algorithms)
RUN curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip > /tmp/jce_policy-8.zip && \
unzip -d /tmp /tmp/jce_policy-8.zip && \
cp /tmp/UnlimitedJCEPolicyJDK8/*.jar /opt/jdk/current/jre/lib/security && \
rm -rf /tmp/jce_policy-8.zip /tmp/UnlimitedJCEPolicy*

# Set root password
RUN echo "root:root" | chpasswd
