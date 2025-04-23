#!/bin/bash

# Colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

# Verificar si kubectl está instalado
if ! command -v kubectl &> /dev/null
then
    echo -e "${RED}Error: kubectl no está instalado. Por favor, instálalo antes de ejecutar este script.${NC}"
    exit 1
fi

# Verificar si los servicios existen antes de intentar el port-forward
SERVICES=("grafana" "prometheus")
NAMESPACES=("monitoring" "monitoring")
PORTS=("3000:3000" "9090:9090")

for i in ${!SERVICES[@]}; do
    SERVICE=${SERVICES[$i]}
    NAMESPACE=${NAMESPACES[$i]}
    PORT=${PORTS[$i]}

    echo "Verificando si el servicio $SERVICE existe en el namespace $NAMESPACE..."
    if ! kubectl get svc $SERVICE -n $NAMESPACE &> /dev/null
    then
        echo -e "${RED}Error: El servicio $SERVICE no existe en el namespace $NAMESPACE.${NC}"
        exit 1
    fi

    echo -e "${GREEN}El servicio $SERVICE existe. Iniciando port-forward en el puerto $PORT...${NC}"
    kubectl port-forward svc/$SERVICE -n $NAMESPACE $PORT &
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: No se pudo iniciar el port-forward para el servicio $SERVICE.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Port-forward para el servicio $SERVICE iniciado con éxito en el puerto $PORT.${NC}"
done

# Mantener el script corriendo para que los port-forwards no se detengan
echo -e "${GREEN}Todos los port-forwards se han iniciado correctamente. Presiona Ctrl+C para detenerlos.${NC}"
wait