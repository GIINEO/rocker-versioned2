FROM docker.io/library/ubuntu:jammy

ENV R_VERSION="4.4.0"
ENV R_HOME="/usr/local/lib/R"
ENV TZ="Asia/Tokyo"

COPY scripts/install_R_source.sh /rocker_scripts/install_R_source.sh
RUN /rocker_scripts/install_R_source.sh

ENV CRAN="https://p3m.dev/cran/__linux__/jammy/latest"
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

COPY scripts/bin/ /rocker_scripts/bin/
COPY scripts/setup_R.sh /rocker_scripts/setup_R.sh
RUN /rocker_scripts/setup_R.sh

COPY scripts/install_tidyverse.sh /rocker_scripts/install_tidyverse.sh
RUN /rocker_scripts/install_tidyverse.sh

COPY scripts/install_analy_packages.sh /rocker_scripts/install_analy_packages.sh
RUN /rocker_scripts/install_analy_packages.sh

COPY scripts/install_analy_packages_4.4.0-4.sh /rocker_scripts/install_analy_packages_4.4.0-4.sh
RUN /rocker_scripts/install_analy_packages_4.4.0-4.sh

ENV S6_VERSION="v2.1.0.2"
ENV RSTUDIO_VERSION="2024.04.0+735"
ENV DEFAULT_USER="rstudio"

COPY scripts/install_rstudio.sh /rocker_scripts/install_rstudio.sh
COPY scripts/install_s6init.sh /rocker_scripts/install_s6init.sh
COPY scripts/default_user.sh /rocker_scripts/default_user.sh
COPY scripts/init_set_env.sh /rocker_scripts/init_set_env.sh
COPY scripts/init_userconf.sh /rocker_scripts/init_userconf.sh
COPY scripts/pam-helper.sh /rocker_scripts/pam-helper.sh
RUN /rocker_scripts/install_rstudio.sh

EXPOSE 8787
CMD ["/init"]

COPY scripts/install_pandoc.sh /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_pandoc.sh

COPY scripts/install_quarto.sh /rocker_scripts/install_quarto.sh
RUN /rocker_scripts/install_quarto.sh

COPY scripts/install_python.sh /rocker_scripts/install_python.sh
COPY scripts/install_pypackages.sh /rocker_scripts/install_pypackages.sh
COPY scripts/requirements/requirements_4.4.0-2.txt /rocker_scripts/requirements.txt
COPY scripts/install_aws_cli.sh /rocker_scripts/install_aws_cli.sh
RUN /rocker_scripts/install_python.sh
RUN /rocker_scripts/install_pypackages.sh
RUN /rocker_scripts/install_aws_cli.sh

COPY scripts /rocker_scripts

RUN sed -i '$d' /etc/locale.gen \
  && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
RUN /bin/bash -c "source /etc/default/locale"
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN apt-get update && apt-get install -y \
  fonts-ipaexfont \
  fonts-noto-cjk
