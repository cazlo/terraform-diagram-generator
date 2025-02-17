ARG TERRAFORM_VERSION=1.10.5
ARG TERRAGRUNT_VERSION=0.73.6
# TARGETARCH is typically set automatically by Docker Buildx.
ARG TARGETARCH=amd64

FROM python:3.12-alpine as py-base

WORKDIR /opt/app

RUN pip install uv==0.6.0

RUN apk update && apk add --no-cache curl grep git

FROM hashicorp/terraform:${TERRAFORM_VERSION} as terraform

RUN which terraform && terraform --version
# bin at /bin/terraform

FROM py-base as terragrunt
ARG TARGETARCH
ARG TERRAGRUNT_VERSION

# Download the binary and its SHA256SUMS, verify the checksum, and install.
RUN set -eux; \
    # Construct the binary file name based on the target architecture.
    bin_filename="terragrunt_linux_${TARGETARCH}"; \
    echo "Downloading Terragrunt version ${TERRAGRUNT_VERSION} for architecture ${TARGETARCH}"; \
    \
    # Download the Terragrunt binary.
    curl -fsSL -o "/tmp/${bin_filename}" "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/${bin_filename}"; \
    \
    # Download the SHA256SUMS file.
    curl -fsSL -o /tmp/SHA256SUMS "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/SHA256SUMS"; \
    \
    # Change to the temporary directory.
    cd /tmp; \
    \
    # Extract the checksum line for our binary and verify it.
    grep "${bin_filename}" SHA256SUMS > checksum.txt; \
    sha256sum -c checksum.txt; \
    \
    # Make the binary executable and move it into PATH.
    chmod +x "/tmp/${bin_filename}"; \
    mv "/tmp/${bin_filename}" /usr/local/bin/terragrunt; \
    \
    # Cleanup temporary files.
    rm /tmp/SHA256SUMS checksum.txt;

RUN terragrunt --version

FROM py-base as py-common
# here we install runtime deps before copying any source over to avoid re-downloading dependencies
COPY pyproject.toml uv.lock .python-version ./
RUN uv sync --no-dev

COPY main.py main.py
#COPY internal internal

FROM py-common as test
COPY --from=terraform /bin/terraform /bin/terraform
COPY --from=terragrunt /usr/local/bin/terragrunt /bin/terragrunt
# here we install only test deps
RUN uv sync --dev
COPY test test
COPY --from=py-common /opt/app/main.py /opt/app/main.py
ENTRYPOINT ["uv", "run", "pytest"]

FROM py-common as runtime
COPY --from=terraform /bin/terraform /bin/terraform
COPY --from=terragrunt /usr/local/bin/terragrunt /bin/terragrunt
ENTRYPOINT ["uv", "run", "main.py"]