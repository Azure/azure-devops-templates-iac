ARG PYTHON_IMAGE_TAG=3.10.6-alpine3.16 \
    PYTHON_MAJOR_VERSION=3.10 \
    PRE_COMMIT_VERSION=2.20.0 \
    TERRAFORM_VERSION=1.3.0 \
    TERRAFORM_DOCS_VERSION=v0.16.0 \
    TFLINT_VERSION=v0.40.1 \
    TFLINT_AZURERM_VERSION=0.18.0 \
    TFSEC_VERSION=1.28.0 \
    TFUPDATE_VERSION=0.6.7 \
    INFRACOST_VERSION=v0.10.11 \
    AZCLI_VERSION=2.39.0 \
    BUILD_DATE \
    VCS_REF \
    VERSION

FROM python:${PYTHON_IMAGE_TAG} as builder

ARG PYTHON_IMAGE_TAG \
    PYTHON_MAJOR_VERSION \
    PRE_COMMIT_VERSION \
    TERRAFORM_VERSION \
    TERRAFORM_DOCS_VERSION \
    TFLINT_VERSION \
    TFLINT_AZURERM_VERSION \
    TFSEC_VERSION \
    TFUPDATE_VERSION \
    INFRACOST_VERSION \
    AZCLI_VERSION

WORKDIR /

#Install pre-commit binaries
RUN apk add --no-cache curl bash gcc make openssl-dev linux-headers libffi-dev musl-dev unzip git perl npm jq go && \
    addgroup -g 1001 user && \
    adduser -G user -h /home/user/ -u 1001 --disabled-password --gecos "" --no-create-home user && \
    mkdir -p /opt/bin_dir/ /home/user/.tflint.d/plugins/ /home/user/.local/bin/ /home/user/.local/lib/python${PYTHON_MAJOR_VERSION}/site-packages/ /home/user/.azure/bin/ /home/user/.cache/pre-commit/ && \
    chown -R user:user /opt/bin_dir/ /home/user/ /home/user/.tflint.d/plugins/ /home/user/.local/bin/ /home/user/.local/lib/python${PYTHON_MAJOR_VERSION}/site-packages/ /home/user/.azure/bin/ /home/user/.cache/pre-commit/

USER user
WORKDIR /home/user/
ENV PATH "/home/user/.local/bin/:/home/user/.tflint.d/plugins/:$PATH"

RUN pip3 install --no-cache --upgrade setuptools wheel pip --user && \
    pip3 install --no-cache pre-commit==${PRE_COMMIT_VERSION} --user && \
    #Get and extract terraform-docs binary
    curl -sSLo /tmp/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz https://github.com/segmentio/terraform-docs/releases/download/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz && \
    tar --directory /opt/bin_dir/ -xzf /tmp/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz terraform-docs && \
    #Get and extract tflint binary
    curl -sSLo /tmp/tflint-ruleset-azurerm-${TFLINT_AZURERM_VERSION}.zip https://github.com/terraform-linters/tflint-ruleset-azurerm/releases/download/v"${TFLINT_AZURERM_VERSION}"/tflint-ruleset-azurerm_linux_amd64.zip && \
    unzip /tmp/tflint-ruleset-azurerm-${TFLINT_AZURERM_VERSION}.zip -d /home/user/.tflint.d/plugins/ && \
    curl -sSLo /tmp/tflint${TFLINT_VERSION}.zip https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip && \
    unzip /tmp/tflint${TFLINT_VERSION}.zip -d /opt/bin_dir/ && \
    #Get and extract tfsec binary
    curl -sSLo /opt/bin_dir/tfsec https://github.com/tfsec/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 && \
    #Get and extract tfupdate binary
    curl -sSLo /tmp/tfupdate-${TFUPDATE_VERSION}-linux-amd64.tar.gz https://github.com/minamijoyo/tfupdate/releases/download/v${TFUPDATE_VERSION}/tfupdate_${TFUPDATE_VERSION}_linux_amd64.tar.gz && \
    tar --directory /opt/bin_dir/ -xzf /tmp/tfupdate-${TFUPDATE_VERSION}-linux-amd64.tar.gz tfupdate && \
    #Get and extract infracost binary
    curl -sSLo /tmp/infracost-${INFRACOST_VERSION}-linux-amd64.tar.gz https://github.com/infracost/infracost/releases/download/${INFRACOST_VERSION}/infracost-linux-amd64.tar.gz && \
    tar --directory /opt/bin_dir/ -xzf /tmp/infracost-${INFRACOST_VERSION}-linux-amd64.tar.gz infracost-linux-amd64 && \
    mv /opt/bin_dir/infracost-linux-amd64 /opt/bin_dir/infracost && \
    #Get and extract Terraform binary
    curl -sSLo /tmp/terraform-${TERRAFORM_VERSION}-linux-amd64.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip /tmp/terraform-${TERRAFORM_VERSION}-linux-amd64.zip -d /opt/bin_dir/ && \
    # Install AZCLI binary
    pip3 install --no-cache azure-cli==${AZCLI_VERSION} --user && \
    az bicep install && \
    #Add executable permissions
    chmod -R +x /opt/bin_dir/* /home/user/.local/bin/pre-commit

#Test binaries
ENV PATH="/opt/bin_dir:/home/user/.tflint.d/plugins:/home/user/.local/bin:$PATH"
RUN pre-commit --version && \
    terraform-docs --version && \
    tflint --version && \
    tfsec --version && \
    terraform --version && \
    infracost --version && \
    tfupdate --version

#Install locally pre-commit-hooks from .pre-commit-config.yaml file
COPY ./.pre-commit-config.yaml .
RUN git init . && \
    pre-commit install-hooks --config .pre-commit-config.yaml && \
    rm -rf .git/ && \
    rm .pre-commit-config.yaml

#Final image build
FROM python:${PYTHON_IMAGE_TAG}

ARG PYTHON_IMAGE_TAG \
    PYTHON_MAJOR_VERSION \
    PRE_COMMIT_VERSION \
    TERRAFORM_VERSION \
    TERRAFORM_DOCS_VERSION \
    TFLINT_VERSION \
    TFLINT_AZURERM_VERSION \
    TFSEC_VERSION \
    TFUPDATE_VERSION \
    INFRACOST_VERSION \
    AZCLI_VERSION \
    BUILD_DATE \
    VCS_REF \
    VERSION

VOLUME /data

WORKDIR /

#Add runtime dependencies, create non-root user and hardening
RUN apk add --no-cache bash git perl npm jq && \
    mkdir -p /data /home/user/.tflint.d/plugins/ /home/user/.local/bin/ /home/user/.local/lib/python${PYTHON_MAJOR_VERSION}/site-packages/ /home/user/.azure/bin/ /home/user/.cache/pre-commit/ && \
    addgroup -g 1001 user && \
    adduser -G user -h /home/user/ -u 1001 --disabled-password --gecos "" --no-create-home user && \
    chmod 0600 /etc/shadow && \
    touch /etc/login.defs && \
    chmod 0444 /etc/login.defs && \
    rm -rf /tmp/*

COPY --from=builder /home/user/.local/bin/* /home/user/.local/bin/
COPY --from=builder /home/user/.local/lib/python${PYTHON_MAJOR_VERSION}/site-packages /home/user/.local/lib/python${PYTHON_MAJOR_VERSION}/site-packages
COPY --from=builder /home/user/.cache/pre-commit/ /home/user/.cache/pre-commit/
COPY --from=builder /home/user/.azure/bin/bicep /home/user/.azure/bin/bicep
COPY --from=builder /opt/bin_dir/* /usr/local/bin/
COPY --from=builder /home/user/.tflint.d/plugins/ /home/user/.tflint.d/plugins/
RUN chown -R user:user /data /home/user/ /home/user/.tflint.d/plugins/ /home/user/.local/bin/ /home/user/.local/lib/python${PYTHON_MAJOR_VERSION}/site-packages/ /home/user/.azure/bin/ /home/user/.cache/pre-commit/
USER user
WORKDIR /home/user/
ENV PATH "/home/user/.local/bin/:/home/user/.tflint.d/plugins/:$PATH"

#Validation
RUN git config --global --add safe.directory /data && \
    pre-commit --version && \
    terraform-docs --version && \
    tflint --version && \
    tfsec --version && \
    terraform --version && \
    infracost --version && \
    tfupdate --version && \
    az --version && \
    ls -lah /home/user/.cache/pre-commit/

WORKDIR /data
ENTRYPOINT ["pre-commit"]

LABEL "maintainer"="maximeroy" \
 "org.label-schema.schema-version"="1.0.0-rc.1" \
 "org.label-schema.name"="pre-commit alpine" \
 "org.label-schema.base-image.name"="docker.io/library/alpine" \
 "org.label-schema.base-image.version"="$PYTHON_IMAGE_TAG" \
 "org.label-schema.description"="pre-commit and dependencies in a container" \
 "org.label-schema.url"="https://pre-commit.com/" \
 "org.label-schema.vcs-url"="https://github.com/ballerinalang/container-support" \
 "org.label-schema.vcs-ref"=$VCS_REF \
 "org.label-schema.applications.pre-commit.version"=$PRE_COMMIT_VERSION \
 "org.label-schema.applications.terraform.version"=$TERRAFORM_VERSION \
 "org.label-schema.applications.terraform-docs.version"=$TERRAFORM_DOCS_VERSION \
 "org.label-schema.applications.tflint.version"=$TFLINT_VERSION \
 "org.label-schema.applications.tflint-azurerm.version"=$TFLINT_AZURERM_VERSION \
 "org.label-schema.applications.tfsec.version"=$TFSEC_VERSION \
 "org.label-schema.applications.tfupdate.version"=$TFUPDATE_VERSION \
 "org.label-schema.applications.infracost.version"=$INFRACOST_VERSION \
 "org.label-schema.applications.azcli.version"=$AZCLI_VERSION \
 "org.label-schema.version"=$VERSION \
 "org.label-schema.build-date"=$BUILD_DATE \
 "org.label-schema.usage"="docker run --rm $(pwd):/data -t docker-pre-commit:main [arguments]"
