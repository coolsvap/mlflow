FROM python:3.7.0
LABEL maintainer="Swapnil Kulkarni"

ENV MLFLOW_USER=mluser
ENV MLFLOW_HOME /home/$MLFLOW_USER/mlflow
ENV MLFLOW_VERSION 1.16.0
ENV SERVER_PORT 5000
ENV SERVER_HOST 0.0.0.0
ENV BACKEND_STORE_URI ${MLFLOW_HOME}/mlruns
ENV ARTIFACT_STORE ${MLFLOW_HOME}/artifactStore

RUN pip install mlflow==${MLFLOW_VERSION} && \
    groupadd mlgroup --gid 5000 && \
    useradd mluser --uid 5000 --gid 5000 --home /home/mluser

EXPOSE ${SERVER_PORT}/tcp

COPY run.sh ${MLFLOW_HOME}/scripts/run.sh

RUN mkdir -p ${MLFLOW_HOME}/scripts && \
    mkdir -p ${BACKEND_STORE_URI} && \
    mkdir -p ${ARTIFACT_STORE} && \
    chown -Rf mluser:mlgroup /home/mluser && \
    chmod +x ${MLFLOW_HOME}/scripts/run.sh


WORKDIR ${MLFLOW_HOME}
USER $MLFLOW_USER
VOLUME ["${BACKEND_STORE_URI}", "${ARTIFACT_STORE}"]
ENTRYPOINT ["./scripts/run.sh"]
