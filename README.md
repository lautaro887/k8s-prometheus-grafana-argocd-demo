# Demo: ArgoCD con Prometheus y Grafana

Este repositorio contiene una demostración de cómo configurar ArgoCD para desplegar:
- Una aplicación mínima de ejemplo
- Prometheus para monitoreo
- Grafana para visualización de métricas

## Instrucciones de uso

### Prerequisitos
- Cluster Kubernetes en funcionamiento
- kubectl configurado para acceder al cluster
- git instalado

### Pasos para la instalación

1. Clonar este repositorio en GitHub:
   ```
   git clone https://github.com/tu-usuario/k8s-prometheus-grafana-argocd-demo.git
   cd k8s-prometheus-grafana-argocd-demo
   ```

2. Instalar ArgoCD:
   ```
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

3. Esperar a que todos los pods de ArgoCD estén en estado "Running":
   ```
   kubectl get pods -n argocd
   ```

4. Crear el proyecto de ArgoCD:
   ```
   kubectl apply -f argocd-setup/project.yaml
   ```

5. Registrar las aplicaciones en ArgoCD:
   ```
   kubectl apply -f argocd-setup/demo-app.yaml
   kubectl apply -f argocd-setup/prometheus.yaml
   kubectl apply -f argocd-setup/grafana.yaml
   ```

6. Acceder a la UI de ArgoCD:
   ```
   # Exponer la interfaz de ArgoCD
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```
   Luego acceder a: https://localhost:8080

7. Credenciales iniciales para ArgoCD:
   - Usuario: admin
   - Contraseña: Para obtener la contraseña inicial:
     ```
     kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
     ```

8. Acceder a Grafana:
   ```
   kubectl port-forward svc/grafana -n monitoring 3000:3000
   ```
   Luego acceder a: http://localhost:3000
   - Usuario: admin
   - Contraseña: admin123

9. Acceder a Prometheus:
   ```
   kubectl port-forward svc/prometheus -n monitoring 9090:9090
   ```
   Luego acceder a: http://localhost:9090

## Modificar la aplicación de demostración

Para modificar la aplicación de demostración y ver cómo ArgoCD sincroniza los cambios automáticamente:

1. Realice cambios en el código del repositorio en la carpeta `apps/demo-app/`.
2. Commit y push de los cambios a GitHub.
3. ArgoCD detectará los cambios y sincronizará automáticamente la aplicación.

## Estructura del repositorio

```
k8s-prometheus-grafana-argocd-demo/
├── argocd-setup/          # Configuración de ArgoCD
├── apps/                  # Aplicaciones para desplegar
│   └── demo-app/          # Aplicación de demostración
└── monitoring/            # Configuración de monitoreo
    ├── prometheus/        # Configuración de Prometheus
    └── grafana/           # Configuración de Grafana
```

## Notas adicionales

- La aplicación de demostración utiliza una imagen de Nginx básica. En un entorno real, se recomendaría usar una aplicación instrumentada con métricas.
- Las contraseñas están en texto plano para simplificar la demostración. En un entorno real, se recomienda usar Kubernetes Secrets.
- La configuración de Prometheus está simplificada para esta demostración.
