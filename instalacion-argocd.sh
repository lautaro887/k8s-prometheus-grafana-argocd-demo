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

# Crear el namespace argocd si no existe
if kubectl get namespace argocd &> /dev/null
then
    echo -e "${GREEN}El namespace 'argocd' ya existe.${NC}"
else
    echo "Creando el namespace 'argocd'..."
    kubectl create namespace argocd
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: No se pudo crear el namespace 'argocd'.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Namespace 'argocd' creado con éxito.${NC}"
fi

# Aplicar el manifiesto de instalación de ArgoCD
echo "Aplicando el manifiesto de instalación de ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: No se pudo aplicar el manifiesto de instalación de ArgoCD.${NC}"
    exit 1
fi

echo -e "${GREEN}Manifiesto de instalación de ArgoCD aplicado con éxito.${NC}"

# Esperar a que todos los pods estén en estado Running
echo "Esperando a que los pods de ArgoCD estén en estado 'Running'..."
while true; do
    PODS_STATUS=$(kubectl get pods -n argocd --no-headers | awk '{print $3}' | grep -vE 'Running|Completed')
    if [ -z "$PODS_STATUS" ]; then
        echo -e "${GREEN}Todos los pods de ArgoCD están en estado 'Running'.${NC}"
        break
    fi
    echo -e "${RED}Algunos pods aún no están en estado 'Running'. Esperando...${NC}"
    sleep 5
done

# Obtener las credenciales iniciales de ArgoCD
echo "Obteniendo las credenciales iniciales de ArgoCD..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: No se pudieron obtener las credenciales iniciales de ArgoCD.${NC}"
    exit 1
fi

echo -e "${GREEN}Credenciales iniciales de ArgoCD obtenidas con éxito.${NC}"
echo -e "Usuario: admin"
echo -e "Contraseña: $ARGOCD_PASSWORD"