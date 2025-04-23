```markdown
# 🚀 Demo: ArgoCD con Prometheus, Grafana y Nginx en Kubernetes

Este repositorio contiene una demostración completa de cómo desplegar una infraestructura básica con ArgoCD, incluyendo:

- Una aplicación mínima de ejemplo (Nginx)
- Prometheus para monitoreo
- Grafana para visualización de métricas

Todo el despliegue está automatizado y preparado para funcionar en **Minikube**, aunque también puede utilizarse en cualquier cluster Kubernetes.

---

## ⚙️ Requisitos previos

- Tener un cluster Kubernetes en funcionamiento (Minikube recomendado para pruebas)
- `kubectl` configurado para acceder al cluster
- `git` instalado
- Bash compatible para ejecutar scripts

---

## 📦 Instalación de ArgoCD

1. Clonar este repositorio:

```bash
git clone https://github.com/tu-usuario/k8s-prometheus-grafana-argocd-demo.git
cd k8s-prometheus-grafana-argocd-demo
```

2. Ejecutar el script de instalación de ArgoCD:

```bash
./instalacion-argocd.sh
```

Este script:
- Crea el namespace `argocd`
- Aplica los manifiestos oficiales de instalación
- Espera a que todos los pods estén listos
- Extrae y muestra las credenciales de acceso (usuario y contraseña)

---

## 🌐 Acceso a la UI de ArgoCD

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Luego abrí en tu navegador: [https://localhost:8080](https://localhost:8080)

**Credenciales:**
- Usuario: `admin`
- Contraseña: (se muestra al finalizar el script de instalación)

---

## 🚀 Desplegar la demo desde la UI de ArgoCD

Una vez dentro de la interfaz web de ArgoCD:

1. Hacé clic en **"NEW APP"**
2. Completá los campos con:

   - **Application Name:** `demo`
   - **Project:** `default`
   - **Repository URL:** `https://github.com/tu-usuario/k8s-prometheus-grafana-argocd-demo.git`
   - **Revision:** `HEAD`
   - **Path:** `argocd-setup/apps`
   - **Sync Policy:** Manual o Automática (a elección)

3. Hacé clic en **"Create"**
4. Luego presioná **"SYNC"** para iniciar el despliegue de toda la infraestructura de la demo (Nginx, Prometheus y Grafana)

---

## 🛠️ Acceso a los servicios desde Minikube

Si estás ejecutando esta demo en Minikube, podés usar el siguiente script para exponer los servicios localmente:

```bash
./minikube-port.sh
```

Este script abrirá los puertos para que puedas acceder a:

- 📈 **Grafana**: [http://localhost:3000](http://localhost:3000)  
  - Usuario: `admin`
  - Contraseña: `admin123`

- 📊 **Prometheus**: [http://localhost:9090](http://localhost:9090)

- 🌐 **Aplicación de demo (Nginx)**: [http://localhost:8081](http://localhost:8081)

---

## ✏️ Modificar la aplicación de demostración

Podés editar el contenido de la aplicación demo en:

```
apps/demo-app/
```

Luego de hacer un **commit + push**, ArgoCD detectará los cambios y sincronizará automáticamente (si usás sync automático), o podés hacer la sincronización manual desde la UI.

---

## 🗂️ Estructura del repositorio

```
k8s-prometheus-grafana-argocd-demo/
├── argocd-setup/          # Configuración de ArgoCD
│   └── apps/              # Declaración de las apps a desplegar
├── apps/                  # Aplicación de demostración (Nginx)
│   └── demo-app/
├── monitoring/            # Configuración de monitoreo
│   ├── prometheus/
│   └── grafana/
├── instalacion-argocd.sh  # Script para instalar ArgoCD
└── minikube-port.sh       # Script para abrir puertos en Minikube
```


